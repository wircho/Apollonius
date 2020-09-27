public final class Midpoint<T, P0: Point, P1: Point> where P0.T == T, P1.T == T {
    let point0: Weak<P0>
    let point1: Weak<P1>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(point0: P0, point1: P1) {
        self.point0 = Weak(point0)
        self.point1 = Weak(point1)
        point0.children.append(.init(self))
        point1.children.append(.init(self))
        for figure in point0.children {
            guard let object = figure.object else { continue }
            let bisector0 = object as? PerpendicularBisector<T, P0, P1>
            let bisector1 = object as? PerpendicularBisector<T, P1, P0>
            if let bisector = bisector0, bisector.point0.object === point0 && bisector.point1.object === point1 {
                bisector.knownPoints.append(.init(self))
                break
            }
            if let bisector = bisector1, bisector.point0.object === point1 && bisector.point1.object === point0 {
                bisector.knownPoints.append(.init(self))
                break
            }
        }
        self.update()
    }
}

extension Midpoint: Point {
    public func update() {
        guard let xy0 = point0.object?.xy, let xy1 = point1.object?.xy, let vector = (xy1 - xy0) / 2 else {
            xy = nil
            return
        }
        xy = xy0 + vector
    }
}
