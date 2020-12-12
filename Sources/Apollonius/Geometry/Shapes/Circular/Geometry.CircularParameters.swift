import Numerics

extension Geometry {
  enum CircularParameters<T: Real & Codable> {
    case _between(center: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _with(center: UnownedPoint<T>, radius: UnownedScalar<T>)
    case _circumcircle(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    case _arc(UnownedPoint<T>, UnownedPoint<T>, UnownedPoint<T>)
    
    static func between(center: Point<T>, tip: Point<T>) -> CircularParameters<T> {
      return ._between(center: .init(center), tip: .init(tip))
    }
    
    static func with(center: Point<T>, radius: Scalar<T>) -> CircularParameters<T> {
      return ._with(center: .init(center), radius: .init(radius))
    }
    
    static func circumcircle(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> CircularParameters<T> {
      return ._circumcircle(.init(point0), .init(point1), .init(point2))
    }
    
    static func arc(_ point0: Point<T>, _ point1: Point<T>, _ point2: Point<T>) -> CircularParameters<T> {
      return ._arc(.init(point0), .init(point1), .init(point2))
    }
  }
}
