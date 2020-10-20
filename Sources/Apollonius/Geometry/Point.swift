import Numerics

public extension Geometry {
  enum PointParameters<T: Real> {
    case free(cursor: Cursor<XY<T>>)
    case _onStraightAbsolute(UnownedStraight<T>, cursor: Cursor<Length<T>>)
    case _onStraightNormalized(UnownedStraight<T>, cursor: Cursor<T>)
    case _onCircular(UnownedCircular<T>, cursor: Cursor<Angle<T>>)
    case _twoStraightsIntersection(UnownedStraight<T>, UnownedStraight<T>)
    case _otherIntersection(UnownedIntersection<T>, index: IntersectionIndex)
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<T>) -> PointParameters<T> {
      return ._onStraightNormalized(.init(straight), cursor: cursor)
    }
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<Length<T>>) -> PointParameters<T> {
      return ._onStraightAbsolute(.init(straight), cursor: cursor)
    }
    
    public static func on(_ circular: Circular<T>, cursor: Cursor<Angle<T>>) -> PointParameters<T> {
      return ._onCircular(.init(circular), cursor: cursor)
    }
    
    public static func intersection(_ intersection: Intersection<T>, index: IntersectionIndex) -> PointParameters<T> {
      return ._otherIntersection(.init(intersection), index: index)
    }
    
    public static func intersection(between straight0: Straight<T>, and straight1: Straight<T>) -> PointParameters<T> {
      return ._twoStraightsIntersection(.init(straight0), .init(straight1))
    }
  }
  
  final class Point<T: Real> {
    public var value: XY<T>? = nil
    public let parameters: PointParameters<T>
    public var children: [UnownedFigure<T>] = []
    public var knwonCurves: [UnownedCurve<T>] = []
    
    public init(_ parameters: PointParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case .free: break
      case let ._onStraightAbsolute(straight, _):
        // Parenting
        straight.inner.object.children.append(.init(self))
        // Known Points
        straight.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(straight.asUnownedCurve)
      case let ._onStraightNormalized(straight,  _):
        // Parenting
        straight.inner.object.children.append(.init(self))
        // Known Points
        straight.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(straight.asUnownedCurve)
      case let ._onCircular(circular,  _):
        // Parenting
        circular.inner.object.children.append(.init(self))
        // Known Points
        circular.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(circular.asUnownedCurve)
      case let ._twoStraightsIntersection(straight0, straight1):
        // Parenting
        straight0.inner.object.children.append(.init(self))
        straight1.inner.object.children.append(.init(self))
        // Known Points
        straight0.inner.object.knownPoints.append(.init(self))
        straight1.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(straight0.asUnownedCurve)
        self.knwonCurves.append(straight1.asUnownedCurve)
      case let ._otherIntersection(intersection, _):
        // Parenting
        intersection.inner.object.children.append(.init(self))
        switch intersection.inner.object.parameters {
        case let .straightCircular(straight, circular):
          // Known Points
          straight.inner.object.knownPoints.append(.init(self))
          circular.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(straight.asUnownedCurve)
          self.knwonCurves.append(circular.asUnownedCurve)
        case let .twoCirculars(circular0, circular1):
          // Known Points
          circular0.inner.object.knownPoints.append(.init(self))
          circular1.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(circular0.asUnownedCurve)
          self.knwonCurves.append(circular1.asUnownedCurve)
        }
      }
    }
  }
}

extension Geometry.Point: Figure {
  public func newValue() -> XY<T>? {
    switch parameters {
    case let .free(cursor):
      return cursor.value
    case let ._onStraightAbsolute(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value)
    case let ._onStraightNormalized(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value * straightValue.length)
    case let ._onCircular(circular, cursor):
      guard let circularValue = circular.inner.object.value else { return nil }
      return circularValue.center + cursor.value.dxy(at: circularValue.radius)
    case let ._otherIntersection(intersection, index):
      return intersection.inner.object[index]
    case let ._twoStraightsIntersection(straight0, straight1):
      guard let straightValue0 = straight0.inner.object.value, let straightValue1 = straight1.inner.object.value else { return nil }
      let origin0 = straightValue0.origin
      let origin1 = straightValue1.origin
      let vector0 = straightValue0.vector
      let vector1 = straightValue1.vector
      let originDifference = origin1 - origin0
      let numerator0 = originDifference.dx * vector1.dy - vector1.dx * originDifference.dy
      let numerator1 = vector0.dx * originDifference.dy - originDifference.dx * vector0.dy
      let denominator = vector0.dx * vector1.dy - vector1.dx * vector0.dy
      guard let value0 = numerator0 / denominator, let value1 = numerator1 / denominator else { return nil }
      guard straight0.inner.object.contains(normalizedValue: value0) == true
        && straight1.inner.object.contains(normalizedValue: value1) == true else {
          return nil
      }
      return origin0 + value0 * vector0
    }
  }
}

public struct UnownedPoint<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Point<T>>
  public let asUnownedFigure: UnownedFigure<T>
  
  init(_ point: Geometry.Point<T>) {
    inner = .init(point)
    asUnownedFigure = .init(point)
  }
}
