import Numerics

struct UnownedStraight<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Straight<T>>
  let asUnownedCurve: UnownedCurve<T>
  var asUnownedShape: UnownedShape<T> { return asUnownedCurve.asUnownedShape }
  
  init(_ straight: Geometry.Straight<T>) {
    inner = .init(straight)
    asUnownedCurve = .init(straight)
  }
}

