import Numerics

public extension Geometry.Intersection {
  static func between(_ straight: Geometry.Straight<T>, _ circular: Geometry.Circular<T>) -> Geometry.Intersection<T> {
    return .init(.between(straight, circular))
  }
  
  static func between(_ circular0: Geometry.Circular<T>, _ circular1: Geometry.Circular<T>) -> Geometry.Intersection<T> {
    return .init(.between(circular0, circular1))
  }
}
