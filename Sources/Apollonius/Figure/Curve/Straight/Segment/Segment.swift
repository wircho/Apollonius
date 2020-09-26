public protocol Segment: Straight where Phantom == SegmentPhantom<T> {}

public enum SegmentPhantom<T: FloatingPoint>: StraightPhantom {
    public func containsNormalizedValue(_ value: T) -> Bool {
        return value >= 0 && value <= 1
    }
}
