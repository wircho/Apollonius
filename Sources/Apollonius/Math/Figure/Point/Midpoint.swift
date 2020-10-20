import Numerics

public final class Midpoint<T: Real> {
    let point0: AnyWeakPoint<T>
    let point1: AnyWeakPoint<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownCurves: [AnyWeakCurve<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init<P0: Point, P1: Point>(point0: P0, point1: P1) where P0.T == T, P1.T == T {
        self.point0 = .init(point0)
        self.point1 = .init(point1)
        self.applyRelationships()
        self.update()
    }
}

extension Midpoint: Point {
    public func update() {
        guard let xy0 = point0.xy, let xy1 = point1.xy, let vector = (xy1 - xy0) / 2 else {
            xy = nil
            return
        }
        xy = xy0 + vector
    }
}
