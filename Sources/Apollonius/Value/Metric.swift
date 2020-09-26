public protocol Metric: Value {}

public struct Squared<M: Metric>: Metric {
    public var value: M.T
    public init(value: M.T) { self.value = value }
}

public extension Squared {
    func squareRoot() -> M? {
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

public func *<M: Metric>(lhs: M, rhs: M) -> Squared<M> {
    return .init(value: lhs.value * rhs.value)
}

public func /<V: Metric>(lhs: V, rhs: V) -> V.T? {
    let ratio = lhs.value / rhs.value
    guard ratio.isFinite else { return nil }
    return ratio
}

public func /<V: Metric>(lhs: Squared<V>, rhs: V) -> V? {
    let ratio = lhs.value / rhs.value
    guard ratio.isFinite else { return nil }
    return .init(value: ratio)
}

