public protocol Ray: Straight where Phantom == RayPhantom<T> {}

public enum RayPhantom<T: FloatingPoint>: StraightPhantom {
    public func containsNormalizedValue(_ value: T) -> Bool {
        return value >= 0
    }
}
