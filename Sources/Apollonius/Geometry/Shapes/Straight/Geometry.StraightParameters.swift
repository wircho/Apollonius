import Numerics

public extension Geometry {
  enum StraightKind: String, Codable {
    case line, segment, ray
  }
  
  enum StraightDirection: String, Codable {
    case parallel, perpendicular
  }
  
  enum StraightDefinition<T: Real & Codable> {
    case _between(origin: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _directed(direction: StraightDirection, origin: UnownedPoint<T>, other: UnownedStraight<T>)
    
    public static func between(_ origin: Point<T>, _ tip: Point<T>) -> StraightDefinition {
      return ._between(origin: .init(origin), tip: .init(tip))
    }
    
    public static func parallel(origin: Point<T>, other: Straight<T>) -> StraightDefinition {
      return ._directed(direction: .parallel, origin: .init(origin), other: .init(other))
    }
    
    public static func perpendicular(origin: Point<T>, other: Straight<T>) -> StraightDefinition {
      return ._directed(direction: .perpendicular, origin: .init(origin), other: .init(other))
    }
    
    public static func directed(_ direction: StraightDirection, origin: Point<T>, other: Straight<T>) -> StraightDefinition {
      return ._directed(direction: direction, origin: .init(origin), other: .init(other))
    }
  }
  
  struct StraightParameters<T: Real & Codable> {
    let kind: StraightKind
    let definition: StraightDefinition<T>
    
    public init(_ kind: StraightKind, _ definition: StraightDefinition<T>) {
      self.kind = kind
      self.definition = definition
    }
    
    public static func straight(_ kind: StraightKind, _ origin: Point<T>, _ tip: Point<T>) -> StraightParameters<T> {
      return .init(kind, .between(origin, tip))
    }
    
    public static func segment(_ origin: Point<T>, _ tip: Point<T>) -> StraightParameters<T> {
      return .straight(.segment, origin, tip)
    }
    
    public static func line(_ origin: Point<T>, _ tip: Point<T>) -> StraightParameters<T> {
      return .straight(.line, origin, tip)
    }
    
    public static func ray(_ origin: Point<T>, _ tip: Point<T>) -> StraightParameters<T> {
      return .straight(.ray, origin, tip)
    }
    
    public static func parallel(origin: Point<T>, other: Straight<T>) -> StraightParameters<T> {
      return .init(.line, .parallel(origin: origin, other: other))
    }
    
    public static func perpendicular(origin: Point<T>, other: Straight<T>) -> StraightParameters<T> {
      return .init(.line, .perpendicular(origin: origin, other: other))
    }
    
    public static func directed(_ direction: StraightDirection, origin: Point<T>, other: Straight<T>) -> StraightParameters<T> {
      return .init(.line, .directed(direction, origin: origin, other: other))
    }
  }
}

