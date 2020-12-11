import Numerics

public struct UnownedIntersection<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Intersection<T>>
  public let asUnownedShape: UnownedShape<T>
  
  init(_ intersection: Geometry.Intersection<T>) {
    inner = .init(intersection)
    asUnownedShape = .init(intersection)
  }
}

