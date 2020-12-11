import Numerics

public struct Length<T: Real & Codable>: Metric {
    public let value: T
    public init(value: T) { self.value = value }
}
