public class PointOnCircular<T, C: Circular> where C.T == T {
    let circular: Weak<C>
    public var position: Angle<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownCurves: [AnyWeakCurve<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(circular: C, position: Angle<T>) {
        self.circular = Weak(circular)
        self.position = position
        self.applyRelationships()
        self.update()
    }
}

extension PointOnCircular: PointOnCurve {
    public func closestPosition(to point: XY<T>) -> Angle<T>? {
        guard let circular = circular.object, let centerXY = circular.centerXY else { return nil }
        return (point - centerXY).angle
    }
    
    public func update() {
        guard let circular = circular.object, let centerXY = circular.centerXY, let radiusLength = circular.radiusLength else {
            xy = nil
            return
        }
        xy = centerXY + radiusLength.dxy(at: position)
    }
}
