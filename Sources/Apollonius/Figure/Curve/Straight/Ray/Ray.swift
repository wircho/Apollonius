import Numerics

public protocol Ray: Straight where Phantom == RayPhantom {}

public enum RayPhantom: StraightPhantom {
    public static func contains<T: Real>(normalizedValue: T) -> Bool {
        return normalizedValue >= 0
    }
}
