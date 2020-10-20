import Numerics

public extension Geometry {
  enum CircularParameters<T: Real> {
    case _between(center: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _with(center: UnownedPoint<T>, radius: UnownedScalar<T>)
    
    public static func between(center: Point<T>, tip: Point<T>) -> CircularParameters<T> {
      return ._between(center: .init(center), tip: .init(tip))
    }
    
    public static func with(center: Point<T>, radius: Scalar<T>) -> CircularParameters<T> {
      return ._with(center: .init(center), radius: .init(radius))
    }
  }
  
  final class Circular<T: Real> {
    public struct Value {
      public let center: XY<T>
      public let radius: Length<T>
      public let interval: AngleInterval<T>?
    }
    
    public var value: Value? = nil
    public let parameters: CircularParameters<T>
    public var children: [UnownedFigure<T>] = []
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
      }
    }
  }
}

extension Geometry.Circular: Curve {
  public func newValue() -> Geometry.Circular<T>.Value? {
    switch parameters {
    case let ._between(center, tip):
      guard let center = center.inner.object.value, let tip = tip.inner.object.value else { return nil }
      return .init(center: center, radius: (tip - center).norm(), interval: nil)
    case let ._with(center, radius):
      guard let center = center.inner.object.value, let radius = radius.inner.object.value else { return nil }
      return .init(center: center, radius: radius, interval: nil)
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

public struct UnownedCircular<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Circular<T>>
  public let asUnownedCurve: UnownedCurve<T>
  // Computed
  public var asUnownedFigure: UnownedFigure<T> { return asUnownedCurve.asUnownedFigure }
  
  init(_ circular: Geometry.Circular<T>) {
    inner = .init(circular)
    asUnownedCurve = .init(circular)
  }
}
