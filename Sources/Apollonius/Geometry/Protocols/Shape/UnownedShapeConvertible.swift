import Numerics

public protocol UnownedShapeConvertible {
  associatedtype T: Real & Codable
  var asUnownedShape: UnownedShape<T> { get }
}

extension UnownedShape: UnownedShapeConvertibleInternal {
  public var asUnownedShape: UnownedShape<T> { return self }
}

public func ==<S: UnownedShapeConvertible>(lhs: S, rhs: S) -> Bool {
  return lhs.asUnownedShape.inner.identifier == rhs.asUnownedShape.inner.identifier
}
