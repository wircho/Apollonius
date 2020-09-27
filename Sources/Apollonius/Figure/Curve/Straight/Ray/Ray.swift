public protocol Ray: Straight where Phantom == RayPhantom {}

public enum RayPhantom: StraightPhantom {
    public static func containsNormalizedValue<T: FloatingPoint>(_ value: T) -> Bool {
        return value >= 0
    }
}
