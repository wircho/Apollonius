public final class StraightPointToPoint<T, Phantom: StraightPhantom, P0: Point, P1: Point> where P0.T == T, P1.T == T {
    let point0: Weak<P0>
    let point1: Weak<P1>
    public var children: [AnyWeakFigure<T>] = []
    public var knownPoints: [AnyWeakPoint<T>]
    public private(set) var xy0: XY<T>? = nil
    public private(set) var xy1: XY<T>? = nil
    
    public init(point0: P0, point1: P1) {
        self.point0 = Weak(point0)
        self.point1 = Weak(point1)
        self.knownPoints = [AnyWeakPoint(point0), AnyWeakPoint(point1)]
        point0.children.append(.init(self))
        point1.children.append(.init(self))
        self.update()
    }
}

extension StraightPointToPoint: Straight {
    public func update() {
        xy0 = point0.object?.xy
        xy1 = point1.object?.xy
    }
}

extension StraightPointToPoint: Line where Phantom == LinePhantom {}
extension StraightPointToPoint: Segment where Phantom == SegmentPhantom {}
extension StraightPointToPoint: Ray where Phantom == RayPhantom {}

