public final class TwoPointsDistance<T, P0: Point, P1: Point> where P0.T == T, P1.T == T {
    let point0: Weak<P0>
    let point1: Weak<P1>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var length: Length<T>? = nil
    
    public init(point0: P0, point1: P1) {
        self.point0 = Weak(point0)
        self.point1 = Weak(point1)
        self.applyRelationships()
        self.update()
    }
}

extension TwoPointsDistance: Scalar {
    public func update() {
        guard let xy0 = point0.object?.xy, let xy1 = point1.object?.xy else {
            length = nil
            return
        }
        length = (xy1 - xy0).norm()
    }
}

