import Numerics

public struct Angle<T: Real>: Value {
    public let value: T
    public init(value: T) { self.value = value }
}

public extension Angle {
    var normalized: Angle {
        let twoPi = 2 * T.pi
        var value = self.value
        while value < 0 { value += twoPi }
        while value >= twoPi { value -= twoPi }
        return .init(value: value)
    }
}
