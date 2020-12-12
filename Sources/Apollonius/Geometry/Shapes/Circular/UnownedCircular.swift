import Numerics

struct UnownedCircular<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Circular<T>>
  let asUnownedCurve: UnownedCurve<T>
  var asUnownedShape: UnownedShape<T> { return asUnownedCurve.asUnownedShape }
  
  init(_ circular: Geometry.Circular<T>) {
    inner = .init(circular)
    asUnownedCurve = .init(circular)
  }
}
