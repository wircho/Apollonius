struct Difference<D: Dimension>: Metric {
    let value: D.T
    init(value: D.T) { self.value = value }
}

typealias _Difference<T: Dimension> = Difference<T>
extension Dimension {
    typealias Difference = _Difference<Self>
}

func +<D: Dimension>(lhs: D, rhs: D.Difference) -> D {
    return .init(value: lhs.value + rhs.value)
}

func -<D: Dimension>(lhs: D, rhs: D) -> D.Difference {
    return .init(value: lhs.value - rhs.value)
}

func -<D: Dimension>(lhs: D, rhs: D.Difference) -> D {
    return .init(value: lhs.value - rhs.value)
}
