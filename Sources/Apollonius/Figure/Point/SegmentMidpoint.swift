public final class SegmentMidpoint<T, S: Segment> where S.T == T {
    let segment: Weak<S>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(segment: S) {
        self.segment = Weak(segment)
        segment.children.append(.init(self))
        segment.knownPoints.append(.init(self))
        self.update()
    }
}

extension SegmentMidpoint: Point {
    public func update() {
        guard let segment = segment.object, let xy0 = segment.xy0, let xy1 = segment.xy1, let vector = (xy1 - xy0) / 2 else {
            xy = nil
            return
        }
        xy = xy0 + vector
    }
}
