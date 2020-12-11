import Numerics

public protocol GeometricCurve: GeometricShape {
  var knownPoints: Set<UnownedPoint<T>> { get set }
}
