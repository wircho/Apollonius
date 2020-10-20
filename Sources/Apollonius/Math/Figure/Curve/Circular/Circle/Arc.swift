public protocol Arc: Circular {
    var interval: AngleInterval<T> { get }
}

public extension Arc {
    func contains(angle: Angle<T>) -> Bool { return interval.contains(angle) }
}
