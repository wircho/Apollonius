import Numerics

extension Geometry.Straight: GeometricCurveInternal {
  public func newValue() -> Geometry.Straight<T>.Value? {
    switch parameters.definition {
    case let ._between(origin, tip):
      guard let xy0 = origin.inner.object.value, let xy1 = tip.inner.object.value else { return nil }
      return .init(origin: xy0, tip: xy1)
    case let ._directed(direction, origin, other):
      guard let xy0 = origin.inner.object.value, let vector = other.inner.object.vector else { return nil }
      switch direction {
      case .parallel: return .init(origin: xy0, tip: xy0 + vector)
      case .perpendicular: return .init(origin: xy0, tip: xy0 + vector.rotated90Degrees)
      }
    }
  }
}
