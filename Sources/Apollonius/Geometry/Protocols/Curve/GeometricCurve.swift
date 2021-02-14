import Numerics

protocol GeometricCurve: GeometricShape {
  var knownPoints: Set<UnownedPoint<T>> { get set }
  var endPoints: Set<UnownedPoint<T>> { get set }
}
