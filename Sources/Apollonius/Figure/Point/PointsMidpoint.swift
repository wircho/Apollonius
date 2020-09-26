public final class PointsMidpoint<T, P0: Point, P1: Point> where P0.T == T, P1.T == T {
    let point0: Weak<P0>
    let point1: Weak<P1>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(point0: P0, point1: P1) {
        self.point0 = Weak(point0)
        self.point1 = Weak(point1)
        point0.children.append(.init(self))
        point1.children.append(.init(self))
        self.update()
    }
}

extension PointsMidpoint: Point {
    public func update() {
        guard let xy0 = point0.object?.xy, let xy1 = point1.object?.xy, let vector = (xy1 - xy0) / 2 else {
            xy = nil
            return
        }
        xy = xy0 + vector
    }
}
