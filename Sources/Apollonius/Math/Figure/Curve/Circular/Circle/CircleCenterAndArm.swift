import Numerics

public final class CircleCenterAndArm<T: Real> {
    let center: AnyWeakPoint<T>
    let arm: AnyWeakPoint<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownPoints: [AnyWeakPoint<T>] = []
    public private(set) var centerXY: XY<T>? = nil
    public private(set) var radiusLength: Length<T>? = nil
    
    public init<C: Point, A: Point>(center: C, arm: A) where C.T == T, A.T == T {
        self.center = .init(center)
        self.arm = .init(arm)
        self.applyRelationships()
        self.update()
    }
}

extension CircleCenterAndArm: Circle {
    public func update() {
        centerXY = center.xy
        guard let centerXY = centerXY, let armXY = arm.xy else {
            radiusLength = nil
            return
        }
        radiusLength = (centerXY - armXY).norm()
    }
}
