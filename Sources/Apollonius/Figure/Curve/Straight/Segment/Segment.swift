import Numerics

public protocol Segment: Straight where Phantom == SegmentPhantom {}

public enum SegmentPhantom: StraightPhantom {
    public static func contains<T: Real>(normalizedValue: T) -> Bool {
        return normalizedValue >= 0 && normalizedValue <= 1
    }
}
