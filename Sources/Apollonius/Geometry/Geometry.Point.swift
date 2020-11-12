import Numerics

public extension Geometry {
  enum PointParameters<T: Real> {
    case fixed(position: XY<T>)
    case free(cursor: Cursor<XY<T>>)
    case _onStraightAbsolute(UnownedStraight<T>, cursor: Cursor<Length<T>>)
    case _onStraightNormalized(UnownedStraight<T>, cursor: Cursor<T>)
    case _onCircular(UnownedCircular<T>, cursor: Cursor<Angle<T>>)
    case _twoStraightsIntersection(UnownedStraight<T>, UnownedStraight<T>)
    case _intersection(UnownedIntersection<T>, index: IntersectionIndex)
    case _oppositeIntersection(UnownedIntersection<T>, oppositePoint: UnownedPoint<T>)
    case _circumcenter(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    
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
      return ._intersection(.init(intersection), index: index)
    }
    
    public static func intersection(_ straight0: Straight<T>, _ straight1: Straight<T>) -> PointParameters<T> {
      return ._twoStraightsIntersection(.init(straight0), .init(straight1))
    }
    
    public static func oppositeIntersection(_ intersection: Intersection<T>, from oppositePoint: Point<T>) -> PointParameters<T> {
      return ._oppositeIntersection(.init(intersection), oppositePoint: .init(oppositePoint))
    }
    
    public static func circumcenter(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> PointParameters<T> {
      return ._circumcenter(.init(point0), .init(point1), .init(point2))
    }
  }
  
  final class Point<T: Real> {
    public let index = GlobalCounter.index
    public var value: XY<T>? = nil
    public let parameters: PointParameters<T>
    public var children: [UnownedShape<T>] = []
    public var knwonCurves: [UnownedCurve<T>] = []
    
    public init(_ parameters: PointParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case .fixed, .free: break
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
      case let ._intersection(intersection, _):
        // Parenting
        intersection.inner.object.children.append(.init(self))
        switch intersection.inner.object.parameters {
        case let ._straightCircular(straight, circular):
          // Known Points
          straight.inner.object.knownPoints.append(.init(self))
          circular.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(straight.asUnownedCurve)
          self.knwonCurves.append(circular.asUnownedCurve)
        case let ._twoCirculars(circular0, circular1):
          // Known Points
          circular0.inner.object.knownPoints.append(.init(self))
          circular1.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(circular0.asUnownedCurve)
          self.knwonCurves.append(circular1.asUnownedCurve)
        }
      case let ._oppositeIntersection(intersection, oppositePoint):
        // Parenting
        intersection.inner.object.children.append(.init(self))
        oppositePoint.inner.object.children.append(.init(self))
        switch intersection.inner.object.parameters {
        case let ._straightCircular(straight, circular):
          // Known Points
          straight.inner.object.knownPoints.append(.init(self))
          circular.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(straight.asUnownedCurve)
          self.knwonCurves.append(circular.asUnownedCurve)
        case let ._twoCirculars(circular0, circular1):
          // Known Points
          circular0.inner.object.knownPoints.append(.init(self))
          circular1.inner.object.knownPoints.append(.init(self))
          // Known Curves
          self.knwonCurves.append(circular0.asUnownedCurve)
          self.knwonCurves.append(circular1.asUnownedCurve)
        }
      case let ._circumcenter(point0, point1, point2):
        // Parenting
        point0.inner.object.children.append(.init(self))
        point1.inner.object.children.append(.init(self))
        point2.inner.object.children.append(.init(self))
      }
    }
  }
}

func _circumcenter<T: Real>(_ xy0: XY<T>, _ xy1: XY<T>, _ xy2: XY<T>) -> XY<T>? { return circumcenter(xy0, xy1, xy2) }

extension Geometry.Point: Shape {
  public func newValue() -> XY<T>? {
    switch parameters {
    case let .fixed(position):
      return position
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
    case let ._intersection(intersection, index):
      return intersection.inner.object[index]
    case let ._oppositeIntersection(intersection, oppositePoint):
      guard let value = intersection.inner.object.value else { return nil }
      return value.opposite(to: oppositePoint.inner.object.value)
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
    case let ._circumcenter(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      return _circumcenter(xy0, xy1, xy2)
    }
  }
}

public extension Geometry.Point {
  static func fixed(position: XY<T>) -> Geometry.Point<T> {
    return .init(.fixed(position: position))
  }
  
  static func free(cursor: Geometry.Cursor<XY<T>>) -> Geometry.Point<T> {
    return .init(.free(cursor: cursor))
  }
  
  static func on(_ straight: Geometry.Straight<T>, cursor: Geometry.Cursor<T>) -> Geometry.Point<T> {
    return .init(.on(straight, cursor: cursor))
  }
  
  static func on(_ straight: Geometry.Straight<T>, cursor: Geometry.Cursor<Length<T>>) -> Geometry.Point<T> {
    return .init(.on(straight, cursor: cursor))
  }
  
  static func on(_ circular: Geometry.Circular<T>, cursor: Geometry.Cursor<Angle<T>>) -> Geometry.Point<T> {
    return .init(.on(circular, cursor: cursor))
  }
  
  static func intersection(_ intersection: Geometry.Intersection<T>, index: Geometry.IntersectionIndex) -> Geometry.Point<T> {
    return .init(.intersection(intersection, index: index))
  }
  
  static func oppositeIntersection(_ intersection: Geometry.Intersection<T>, from oppositePoint: Geometry.Point<T>) -> Geometry.Point<T> {
    return .init(.oppositeIntersection(intersection, from: oppositePoint))
  }
  
  static func intersection(_ straight0: Geometry.Straight<T>, _ straight1: Geometry.Straight<T>) -> Geometry.Point<T> {
    return .init(.intersection(straight0, straight1))
  }
  
  static func circumcenter(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Point<T> {
    return .init(.circumcenter(point0, point1, point2))
  }
}

public struct UnownedPoint<T: Real>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Point<T>>
  public let asUnownedShape: UnownedShape<T>
  
  init(_ point: Geometry.Point<T>) {
    inner = .init(point)
    asUnownedShape = .init(point)
  }
}
