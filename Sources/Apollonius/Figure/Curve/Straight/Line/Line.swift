public protocol Line: Straight where Phantom == LinePhantom {}

public enum LinePhantom: StraightPhantom {
    public static func containsNormalizedValue<T: FloatingPoint>(_ value: T) -> Bool {
        return true
    }
}
