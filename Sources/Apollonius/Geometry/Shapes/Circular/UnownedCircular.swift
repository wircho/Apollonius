import Numerics

public struct UnownedCircular<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Circular<T>>
  public let asUnownedCurve: UnownedCurve<T>
  public var asUnownedShape: UnownedShape<T> { return asUnownedCurve.asUnownedShape }
  
  init(_ circular: Geometry.Circular<T>) {
    inner = .init(circular)
    asUnownedCurve = .init(circular)
  }
}
