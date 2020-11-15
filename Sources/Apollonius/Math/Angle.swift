import Numerics

public struct Angle<T: Real & Codable>: Value {
    public let value: T
    public init(value: T) { self.value = value }
}

public extension Angle {
    var normalized: Angle {
        let twoPi = 2 * T.pi
        var value = self.value
        while value < 0 { value += twoPi }
        while value >= twoPi { value -= twoPi }
        return .init(value: value)
    }
    
    var cos: T { return .cos(value) }
    var sin: T { return .sin(value) }
    
    func dxy(at length: Length<T>) -> DXY<T> {
        return .init(
            dx: (cos * length).asDX,
            dy: (sin * length).asDY
        )
    }
}

public extension Length {
    func dxy(at angle: Angle<T>) -> DXY<T> {
        return angle.dxy(at: self)
    }
}
