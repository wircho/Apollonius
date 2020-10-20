public class PointOnSegment<T, S: Segment> where S.T == T {
    let segment: Weak<S>
    public var straight: S? { return segment.object }
    public var position: T
    public var children: [AnyWeakFigure<T>] = []
    public var knownCurves: [AnyWeakCurve<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(segment: S, position: T) {
        self.segment = Weak(segment)
        self.position = position
        self.applyRelationships()
        self.update()
    }
}

extension PointOnSegment: PointOnStraight {
    public func position(for length: Length<T>, on norm: Length<T>) -> T? {
        guard let result = length / norm else { return nil }
        guard result >= 0 else { return 0 }
        guard result <= 1 else { return 1 }
        return result
    }
    
    public func update() {
        guard let segment = segment.object, let origin = segment.xy0, let vector = segment.vector else {
            xy = nil
            return
        }
        xy = origin + position * vector
    }
}
