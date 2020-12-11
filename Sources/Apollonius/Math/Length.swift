import Numerics

public struct Length<T: Real & Codable>: Metric {
    public let value: T
    init(value: T) { self.value = value }
}
