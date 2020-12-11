import Numerics

public struct UnownedScalar<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Scalar<T>>
  public let asUnownedShape: UnownedShape<T>
  
  init(_ scalar: Geometry.Scalar<T>) {
    inner = .init(scalar)
    asUnownedShape = .init(scalar)
  }
}

