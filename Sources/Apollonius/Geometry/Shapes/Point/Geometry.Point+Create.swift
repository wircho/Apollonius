import Numerics

extension Geometry.Point {
  static func fixed(position: XY<T>) -> Geometry.Point<T> {
    return .init(.fixed(position: position))
  }
  
  static func free(cursor: Geometry.Cursor<XY<T>>) -> Geometry.Point<T> {
    return .init(.free(cursor: cursor))
  }
  
  static func on(_ straight: Geometry.Straight<T>, cursor: Geometry.Cursor<T>) -> Geometry.Point<T> {
    return .init(.on(straight, cursor: cursor))
  }
  
  static func on(_ straight: Geometry.Straight<T>, cursor: Geometry.Cursor<Length<T>>) -> Geometry.Point<T> {
    return .init(.on(straight, cursor: cursor))
  }
  
  static func on(_ circular: Geometry.Circular<T>, cursor: Geometry.Cursor<SimpleAngle<T>>) -> Geometry.Point<T> {
    return .init(.on(circular, cursor: cursor))
  }
  
  static func intersection(_ intersection: Geometry.Intersection<T>, index: Geometry.IntersectionIndex) -> Geometry.Point<T> {
    return .init(.intersection(intersection, index: index))
  }
  
  static func oppositeIntersection(_ intersection: Geometry.Intersection<T>, from oppositePoint: Geometry.Point<T>) -> Geometry.Point<T> {
    return .init(.oppositeIntersection(intersection, from: oppositePoint))
  }
  
  static func intersection(_ straight0: Geometry.Straight<T>, _ straight1: Geometry.Straight<T>) -> Geometry.Point<T> {
    return .init(.intersection(straight0, straight1))
  }
  
  static func circumcenter(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) -> Geometry.Point<T> {
    return .init(.circumcenter(point0, point1, point2))
  }
}
