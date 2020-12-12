import Numerics

extension Geometry {
  enum IntersectionParameters<T: Real & Codable> {
    case _straightCircular(UnownedStraight<T>, UnownedCircular<T>)
    case _twoCirculars(UnownedCircular<T>, UnownedCircular<T>)
    
    static func between(_ straight: Straight<T>, _ circular: Circular<T>) -> IntersectionParameters<T> {
      return ._straightCircular(.init(straight), .init(circular))
    }
    
    static func between(_ circular0: Circular<T>, _ circular1: Circular<T>) -> IntersectionParameters<T> {
      return ._twoCirculars(.init(circular0), .init(circular1))
    }
  }
}

