import Numerics

public extension Geometry {
  enum ScalarParameters<T: Real & Codable> {
    case _distance(_ point0: UnownedPoint<T>, _ point1: UnownedPoint<T>)
    
    public static func distance(_ point0: Point<T>, _ point1: Point<T>) -> ScalarParameters<T> {
      return ._distance(.init(point0), .init(point1))
    }
  }
}


