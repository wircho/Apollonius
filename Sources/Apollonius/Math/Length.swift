import Numerics

struct Length<T: Real & Codable>: Metric {
    let value: T
    init(value: T) { self.value = value }
}
