import Numerics

public final class StraightPointToPoint<T: Real, Phantom: StraightPhantom> {
    let point0: AnyWeakPoint<T>
    let point1: AnyWeakPoint<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownPoints: [AnyWeakPoint<T>] = []
    public private(set) var xy0: XY<T>? = nil
    public private(set) var xy1: XY<T>? = nil
    
    public init<P0: Point, P1: Point>(point0: P0, point1: P1) where P0.T == T, P1.T == T {
        self.point0 = .init(point0)
        self.point1 = .init(point1)
        self.applyRelationships()
        self.update()
    }
}

extension StraightPointToPoint: Straight {
    public func update() {
        xy0 = point0.xy
        xy1 = point1.xy
    }
}

extension StraightPointToPoint: Line where Phantom == LinePhantom {}
extension StraightPointToPoint: Segment where Phantom == SegmentPhantom {}
extension StraightPointToPoint: Ray where Phantom == RayPhantom {}

