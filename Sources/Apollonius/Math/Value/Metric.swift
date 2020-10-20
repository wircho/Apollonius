public protocol Metric: Value {}

public struct Multiplied<M0: Metric, M1: Metric>: Metric where M0.T == M1.T {
    public let value: M0.T
    public init(value: M0.T) { self.value = value }
}

public extension Multiplied {
    var commuted: Multiplied<M1, M0> { return .init(value: value) }
}

public typealias Squared<M: Metric> = Multiplied<M, M>

public extension Multiplied where M0 == M1 {
    func squareRoot() -> M0? {
        let squareRoot = value.squareRoot()
        guard squareRoot.isFinite else { return nil }
        return .init(value: squareRoot)
    }
}

public extension Metric {
    func squared() -> Squared<Self> {
        return .init(value: value.squared())
    }
}

public func +<M: Metric>(lhs: M, rhs: M) -> M {
    return .init(value: lhs.value + rhs.value)
}

public prefix func -<M: Metric>(value: M) -> M {
    return .init(value: -value.value)
}

public func -<M: Metric>(lhs: M, rhs: M) -> M {
    return .init(value: lhs.value - rhs.value)
}

public func *<M: Metric>(lhs: M.T, rhs: M) -> M {
    return .init(value: lhs * rhs.value)
}

public func *<M0: Metric, M1: Metric>(lhs: M0, rhs: M1) -> Multiplied<M0, M1> {
    return .init(value: lhs.value * rhs.value)
}

public func /<M: Metric>(lhs: M, rhs: M.T) -> M? {
    let ratio = lhs.value / rhs
    guard ratio.isFinite else { return nil }
    return .init(value: ratio)
}

public func /<M: Metric>(lhs: M, rhs: M) -> M.T? {
    let ratio = lhs.value / rhs.value
    guard ratio.isFinite else { return nil }
    return ratio
}

public func /<M0: Metric, M1: Metric>(lhs: Multiplied<M0, M1>, rhs: M1) -> M0? {
    let ratio = lhs.value / rhs.value
    guard ratio.isFinite else { return nil }
    return .init(value: ratio)
}
