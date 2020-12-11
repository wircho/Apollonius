import Numerics

public struct SimpleAngle<T: Real & Codable>: SimpleValue {
    public let value: T
    init(value: T) { self.value = value }
}

extension SimpleAngle {
    var normalized: SimpleAngle {
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

extension Length {
    func dxy(at angle: SimpleAngle<T>) -> DXY<T> {
        return angle.dxy(at: self)
    }
}
