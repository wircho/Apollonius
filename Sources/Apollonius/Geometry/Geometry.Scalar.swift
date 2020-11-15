import Numerics

public extension Geometry {
  enum ScalarParameters<T: Real> {
    case _distance(_ point0: UnownedPoint<T>, _ point1: UnownedPoint<T>)
    
    public static func distance(_ point0: Point<T>, _ point1: Point<T>) -> ScalarParameters<T> {
      return ._distance(.init(point0), .init(point1))
    }
  }
  
  final class Scalar<T: Real> {
    public let index = Counter.shapes.newIndex()
    public var value: Length<T>? = nil
    public let parameters: ScalarParameters<T>
    public var children: [UnownedShape<T>] = []
    
    public init(_ parameters: ScalarParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let ._distance(point0, point1):
        // Parenting
        point0.asUnownedShape.append(child: .init(self))
        point1.asUnownedShape.append(child: .init(self))
      }
    }
  }
}

extension Geometry.Scalar: ShapeInternal {
  public func newValue() -> Length<T>? {
    switch parameters {
    case let ._distance(point0, point1):
      guard let xy0 = point0.inner.object.value, let xy1 = point1.inner.object.value else { return nil }
      return (xy1 - xy0).norm()
    }
  }
}

public extension Geometry.Scalar {
  static func distance(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>) -> Geometry.Scalar<T> {
    return .init(.distance(point0, point1))
  }
}

public struct UnownedScalar<T: Real>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Scalar<T>>
  public let asUnownedShape: UnownedShape<T>
  
  init(_ scalar: Geometry.Scalar<T>) {
    inner = .init(scalar)
    asUnownedShape = .init(scalar)
  }
}
