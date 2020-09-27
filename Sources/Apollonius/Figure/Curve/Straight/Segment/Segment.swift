public protocol Segment: Straight where Phantom == SegmentPhantom {}

public enum SegmentPhantom: StraightPhantom {
    public static func containsNormalizedValue<T: FloatingPoint>(_ value: T) -> Bool {
        return value >= 0 && value <= 1
    }
}
