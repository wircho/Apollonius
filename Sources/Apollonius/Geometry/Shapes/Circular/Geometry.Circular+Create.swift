import Numerics

extension Geometry.Circular {
  static func centered(at center: Geometry.Point<T>, through tip: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.between(center: center, tip: tip))
  }
  
  static func centered(at center: Geometry.Point<T>, radius: Geometry.Scalar<T>) -> Geometry.Circular<T> {
    return .init(.with(center: center, radius: radius))
  }
  
  static func circumscribing(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.circumcircle(point0, point1, point2))
  }
  
  static func arcCircumscribing(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Circular<T> {
    return .init(.arc(point0, point1, point2))
  }
}
