import Numerics

public struct AngleInterval<T: Real> {
    public let angle0: Angle<T>
    public let angle1: Angle<T>
    
    public init(angle0: Angle<T>, angle1: Angle<T>) {
        self.angle0 = angle0
        self.angle1 = angle1
    }
}

public extension AngleInterval {
    func contains(_ angle: Angle<T>) -> Bool {
        let angle = angle.normalized
        let angle0 = self.angle0.normalized
        let angle1 = self.angle1.normalized
        switch angle0 <= angle1 {
        case true: return angle0 <= angle && angle <= angle1
        case false: return angle0 <= angle || angle <= angle1
        }
    }
}


