import Numerics

public protocol Value: Comparable {
    associatedtype T: Real
    var value: T { get }
    init(value: T)
}

public extension Value  {
    static func ==(lhs: Self, rhs: Self) -> Bool { return lhs.value == rhs.value }
    static func <(lhs: Self, rhs: Self) -> Bool { return lhs.value < rhs.value }
}
