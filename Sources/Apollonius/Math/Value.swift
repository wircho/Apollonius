import Numerics

public protocol SimpleValue: Comparable {
    associatedtype T: Real & Codable
    var value: T { get }
    init(value: T)
}

public extension SimpleValue  {
    static func ==(lhs: Self, rhs: Self) -> Bool { return lhs.value == rhs.value }
    static func <(lhs: Self, rhs: Self) -> Bool { return lhs.value < rhs.value }
}

public extension SimpleValue  {
    static func ==(lhs: Self, rhs: Self.T) -> Bool { return lhs.value == rhs }
    static func <(lhs: Self, rhs: Self.T) -> Bool { return lhs.value < rhs }
    static func <=(lhs: Self, rhs: Self.T) -> Bool { return lhs < rhs || lhs == rhs }
    static func >(lhs: Self, rhs: Self.T) -> Bool { return !(lhs <= rhs) }
    static func >=(lhs: Self, rhs: Self.T) -> Bool { return !(lhs < rhs) }
}
