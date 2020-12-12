import Numerics

protocol UnownedShapeConvertible {
  associatedtype T: Real & Codable
  var asUnownedShape: UnownedShape<T> { get }
}

extension UnownedShape: UnownedShapeConvertibleInternal {
  var asUnownedShape: UnownedShape<T> { return self }
}

func ==<S: UnownedShapeConvertible>(lhs: S, rhs: S) -> Bool {
  return lhs.asUnownedShape.inner.identifier == rhs.asUnownedShape.inner.identifier
}
