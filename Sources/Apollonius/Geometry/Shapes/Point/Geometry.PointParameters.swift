import Numerics

public extension Geometry {
  enum IntersectionIndex: String, Codable {
    case first, second
  }
  
  enum PointParameters<T: Real & Codable> {
    case fixed(position: XY<T>)
    case free(cursor: Cursor<XY<T>>)
    case _onStraightAbsolute(UnownedStraight<T>, cursor: Cursor<Length<T>>)
    case _onStraightNormalized(UnownedStraight<T>, cursor: Cursor<T>)
    case _onCircular(UnownedCircular<T>, cursor: Cursor<SimpleAngle<T>>)
    case _twoStraightsIntersection(UnownedStraight<T>, UnownedStraight<T>)
    case _intersection(UnownedIntersection<T>, index: IntersectionIndex)
    case _oppositeIntersection(UnownedIntersection<T>, oppositePoint: UnownedPoint<T>)
    case _circumcenter(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<T>) -> PointParameters<T> {
      return ._onStraightNormalized(.init(straight), cursor: cursor)
    }
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<Length<T>>) -> PointParameters<T> {
      return ._onStraightAbsolute(.init(straight), cursor: cursor)
    }
    
    public static func on(_ circular: Circular<T>, cursor: Cursor<SimpleAngle<T>>) -> PointParameters<T> {
      return ._onCircular(.init(circular), cursor: cursor)
    }
    
    public static func intersection(_ intersection: Intersection<T>, index: IntersectionIndex) -> PointParameters<T> {
      return ._intersection(.init(intersection), index: index)
    }
    
    public static func intersection(_ straight0: Straight<T>, _ straight1: Straight<T>) -> PointParameters<T> {
      return ._twoStraightsIntersection(.init(straight0), .init(straight1))
    }
    
    public static func oppositeIntersection(_ intersection: Intersection<T>, from oppositePoint: Point<T>) -> PointParameters<T> {
      return ._oppositeIntersection(.init(intersection), oppositePoint: .init(oppositePoint))
    }
    
    public static func circumcenter(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> PointParameters<T> {
      return ._circumcenter(.init(point0), .init(point1), .init(point2))
    }
  }
}

