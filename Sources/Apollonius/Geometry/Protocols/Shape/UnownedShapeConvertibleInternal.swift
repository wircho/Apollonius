import Numerics

protocol UnownedShapeConvertibleInternal: UnownedShapeConvertible {
  associatedtype ObjectType: AnyObject
  var inner: Unowned<ObjectType> { get }
}

func ==<S0: GeometricShape, S1: UnownedShapeConvertibleInternal>(lhs: S0, rhs: S1) -> Bool where S1.ObjectType == S0, S0.T == S1.T {
  return lhs === rhs.asUnownedShape.inner.object
}

func ==<S0: UnownedShapeConvertibleInternal, S1: GeometricShape>(lhs: S0, rhs: S1) -> Bool where S0.ObjectType == S1, S0.T == S1.T {
  return lhs.asUnownedShape.inner.object === rhs
}
