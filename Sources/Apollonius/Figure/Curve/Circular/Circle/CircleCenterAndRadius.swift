public final class CircleCenterAndRadius<T, C: Point, A: Point> where C.T == T, A.T == T {
    let center: Weak<C>
    let arm: Weak<A>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var centerXY: XY<T>? = nil
    public private(set) var radius: Length<T>? = nil
    public let knownPoints: [AnyWeakPoint<T>]
    
    public init(center: C, arm: A) {
        self.center = Weak(center)
        self.arm = Weak(arm)
        self.knownPoints = [AnyWeakPoint(arm)]
        center.children.append(.init(self))
        arm.children.append(.init(self))
        self.update()
    }
}

extension CircleCenterAndRadius: Circular {
    public func update() {
        centerXY = center.object?.xy
        guard let centerXY = centerXY, let armXY = arm.object?.xy else {
            radius = nil
            return
        }
        radius = (centerXY - armXY).norm()
    }
}
