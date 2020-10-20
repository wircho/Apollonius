public final class CircleCenterAndRadius<T> {
    let center: AnyWeakPoint<T>
    let radius: AnyWeakScalar<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownPoints: [AnyWeakPoint<T>] = []
    public private(set) var centerXY: XY<T>? = nil
    public private(set) var radiusLength: Length<T>? = nil
    
    public init<C: Point, R: Scalar>(center: C, radius: R) where C.T == T, R.T == T {
        self.center = Weak(center)
        self.radius = Weak(radius)
        self.applyRelationships()
        self.update()
    }
}

extension CircleCenterAndRadius: Circle {
    public func update() {
        centerXY = center.object?.xy
        guard let radiusLength = radius.object?.length else {
            self.radiusLength = nil
            return
        }
        self.radiusLength = radiusLength
    }
}
