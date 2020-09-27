public final class PerpendicularBisector<T, P0: Point, P1: Point> where P0.T == T, P1.T == T {
    let point0: Weak<P0>
    let point1: Weak<P1>
    public var children: [AnyWeakFigure<T>] = []
    public var knownPoints: [AnyWeakPoint<T>] = []
    public private(set) var xy0: XY<T>? = nil
    public private(set) var xy1: XY<T>? = nil
    
    public init(point0: P0, point1: P1) {
        self.point0 = Weak(point0)
        self.point1 = Weak(point1)
        point0.children.append(.init(self))
        point1.children.append(.init(self))
        for figure in point0.children {
            guard let object = figure.object else { continue }
            let midpoint0 = object as? Midpoint<T, P0, P1>
            let midpoint1 = object as? Midpoint<T, P1, P0>
            if let midpoint = midpoint0, midpoint.point0.object === point0 && midpoint.point1.object === point1 {
                self.knownPoints.append(.init(midpoint))
                break
            }
            if let midpoint = midpoint1, midpoint.point0.object === point1 && midpoint.point1.object === point0 {
                self.knownPoints.append(.init(midpoint))
                break
            }
        }
        self.update()
    }
}

extension PerpendicularBisector: Line {
    public typealias Phantom = LinePhantom
    public func update() {
        guard let p0 = point0.object?.xy, let p1 = point1.object?.xy, let vector = (p1 - p0) / 2 else {
            xy0 = nil
            xy1 = nil
            return
        }
        xy0 = p0 + vector
        xy1 = xy0.map{ $0 + vector.rotated90Degrees }
    }
}

