import Numerics

public protocol Line: Straight where Phantom == LinePhantom {}

public enum LinePhantom: StraightPhantom {
    public static func contains<T: Real>(normalizedValue: T) -> Bool {
        return true
    }
}
