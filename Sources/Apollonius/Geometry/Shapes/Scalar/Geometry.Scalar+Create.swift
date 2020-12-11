import Numerics

public extension Geometry.Scalar {
  static func distance(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>) -> Geometry.Scalar<T> {
    return .init(.distance(point0, point1))
  }
}
