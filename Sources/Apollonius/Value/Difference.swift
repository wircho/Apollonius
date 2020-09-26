public struct Difference<D: Dimension>: Metric {
    public var value: D.T
    public init(value: D.T) { self.value = value }
}

public typealias _Difference<T: Dimension> = Difference<T>
public extension Dimension {
    typealias Difference = _Difference<Self>
}

public func +<D: Dimension>(lhs: D, rhs: D.Difference) -> D {
    return .init(value: lhs.value + rhs.value)
}

public func -<D: Dimension>(lhs: D, rhs: D) -> D.Difference {
    return .init(value: lhs.value - rhs.value)
}

public func -<D: Dimension>(lhs: D, rhs: D.Difference) -> D {
    return .init(value: lhs.value - rhs.value)
}
