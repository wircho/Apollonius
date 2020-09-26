public protocol Line: Straight where Phantom == LinePhantom<T> {}

public enum LinePhantom<T: FloatingPoint>: StraightPhantom {
    public func containsNormalizedValue(_ value: T) -> Bool {
        return true
    }
}
