import Numerics

extension Geometry.Scalar: GeometricShape {
  func newValue() -> Length<T>? {
    switch parameters {
    case let ._distance(point0, point1):
      guard let xy0 = point0.inner.object.value, let xy1 = point1.inner.object.value else { return nil }
      return (xy1 - xy0).norm()
    }
  }
}
