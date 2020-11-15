import Numerics

public extension Geometry {
  enum CircularParameters<T: Real> {
    case _between(center: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _with(center: UnownedPoint<T>, radius: UnownedScalar<T>)
    case _circumcircle(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    case _arc(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    
    public static func between(center: Point<T>, tip: Point<T>) -> CircularParameters<T> {
      return ._between(center: .init(center), tip: .init(tip))
    }
    
    public static func with(center: Point<T>, radius: Scalar<T>) -> CircularParameters<T> {
      return ._with(center: .init(center), radius: .init(radius))
    }
    
    public static func circumcircle(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> CircularParameters<T> {
      return ._circumcircle(.init(point0), .init(point1), .init(point2))
    }
    
    public static func arc(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> CircularParameters<T> {
      return ._arc(.init(point0), .init(point1), .init(point2))
    }
  }
  
  final class Circular<T: Real> {
    public struct Value {
      public let center: XY<T>
      public let radius: Length<T>
      public let interval: AngleInterval<T>?
    }
    
    public let index = Counter.shapes.newIndex()
    public var value: Value? = nil
    public let parameters: CircularParameters<T>
    public var children: [UnownedShape<T>] = []
    public var knownPoints: [UnownedPoint<T>] = []
    
    public init(_ parameters: CircularParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let ._between(center, tip):
        // Parenting
        center.inner.object.children.append(.init(self))
        tip.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(tip)
        // Known Curves
        tip.inner.object.knwonCurves.append(.init(self))
      case let ._with(center, radius):
        // Parenting
        center.inner.object.children.append(.init(self))
        radius.inner.object.children.append(.init(self))
      case let ._circumcircle(point0, point1, point2):
        // Parenting
        point0.inner.object.children.append(.init(self))
        point1.inner.object.children.append(.init(self))
        point2.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(point0)
        knownPoints.append(point1)
        knownPoints.append(point2)
        // Known Curves
        point0.inner.object.knwonCurves.append(.init(self))
        point1.inner.object.knwonCurves.append(.init(self))
        point2.inner.object.knwonCurves.append(.init(self))
      case let ._arc(point0, point1, point2):
        // Parenting
        point0.inner.object.children.append(.init(self))
        point1.inner.object.children.append(.init(self))
        point2.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(point0)
        knownPoints.append(point1)
        knownPoints.append(point2)
        // Known Curves
        point0.inner.object.knwonCurves.append(.init(self))
        point1.inner.object.knwonCurves.append(.init(self))
        point2.inner.object.knwonCurves.append(.init(self))
      }
    }
  }
}

extension Geometry.Circular: Curve, ShapeInternal {
  public func newValue() -> Geometry.Circular<T>.Value? {
    switch parameters {
    case let ._between(center, tip):
      guard let center = center.inner.object.value, let tip = tip.inner.object.value else { return nil }
      return .init(center: center, radius: (tip - center).norm(), interval: nil)
    case let ._with(center, radius):
      guard let center = center.inner.object.value, let radius = radius.inner.object.value else { return nil }
      return .init(center: center, radius: radius, interval: nil)
    case let ._circumcircle(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      guard let center = circumcenter(xy0, xy1, xy2) else { return nil }
      let radius = (xy0 - center).norm()
      return .init(center: center, radius: radius, interval: nil)
    case let ._arc(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      guard let center = circumcenter(xy0, xy1, xy2) else { return nil }
      guard let angle0 = (xy0 - center).angle, let angle1 = (xy1 - center).angle, let angle2 = (xy2 - center).angle else { return nil }
      let radius = (xy0 - center).norm()
      let interval = AngleInterval(angle0, angle1, angle2)
      return .init(center: center, radius: radius, interval: interval)
    }
  }
}

public extension Geometry.Circular {
  func contains(angle: Angle<T>) -> Bool? {
    guard let value = self.value else { return nil }
    return value.interval?.contains(angle) ?? true
  }
}

public extension Geometry.Circular {
  func cursorValue(near xy: XY<T>) -> Angle<T>? {
    guard let center = value?.center else { return nil }
    return (xy - center).angle
  }
}

public extension Geometry.Circular {
  static func centered(at center: Geometry.Point<T>, through tip: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.between(center: center, tip: tip))
  }
  
  static func centered(at center: Geometry.Point<T>, radius: Geometry.Scalar<T>) -> Geometry.Circular<T> {
    return .init(.with(center: center, radius: radius))
  }
  
  static func circumscribing(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.circumcircle(point0, point1, point2))
  }
  
  static func arcCircumscribing(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.arc(point0, point1, point2))
  }
}

public struct UnownedCircular<T: Real>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Circular<T>>
  public let asUnownedCurve: UnownedCurve<T>
  // Computed
  public var asUnownedShape: UnownedShape<T> { return asUnownedCurve.asUnownedShape }
  
  init(_ circular: Geometry.Circular<T>) {
    inner = .init(circular)
    asUnownedCurve = .init(circular)
  }
}
