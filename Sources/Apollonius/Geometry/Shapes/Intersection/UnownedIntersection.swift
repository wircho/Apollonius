import Numerics

struct UnownedIntersection<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Intersection<T>>
  let asUnownedShape: UnownedShape<T>
  
  init(_ intersection: Geometry.Intersection<T>) {
    inner = .init(intersection)
    asUnownedShape = .init(intersection)
  }
}

