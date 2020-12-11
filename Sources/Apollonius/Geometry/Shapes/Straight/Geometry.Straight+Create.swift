import Numerics

extension Geometry.Straight {
  public static func straight(_ kind: Geometry.StraightKind, _ origin: Geometry.Point<T>, _ tip: Geometry.Point<T>) -> Geometry.Straight<T> {
    return .init(.straight(kind, origin, tip))
  }
  
  public static func segment(_ origin: Geometry.Point<T>, _ tip: Geometry.Point<T>) -> Geometry.Straight<T> {
    return .init(.segment(origin, tip))
  }
  
  public static func line(_ origin: Geometry.Point<T>, _ tip: Geometry.Point<T>) -> Geometry.Straight<T> {
    return .init(.line(origin, tip))
  }
  
  public static func ray(_ origin: Geometry.Point<T>, _ tip: Geometry.Point<T>) -> Geometry.Straight<T> {
    return .init(.ray(origin, tip))
  }
  
  public static func parallel(origin: Geometry.Point<T>, other: Geometry.Straight<T>) -> Geometry.Straight<T> {
    return .init(.parallel(origin: origin, other: other))
  }
  
  public static func perpendicular(origin: Geometry.Point<T>, other: Geometry.Straight<T>) -> Geometry.Straight<T> {
    return .init(.perpendicular(origin: origin, other: other))
  }
  
  public static func directed(_ direction: Geometry.StraightDirection, origin: Geometry.Point<T>, other: Geometry.Straight<T>) -> Geometry.Straight<T> {
    return .init(.directed(direction, origin: origin, other: other))
  }
}
