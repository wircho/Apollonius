import Numerics

public final class SegmentLength<T: Real> {
    let segment: AnyWeakSegment<T>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var length: Length<T>? = nil
    
    public init<S: Segment>(segment: S) where S.T == T {
        self.segment = .init(segment)
        self.applyRelationships()
        self.update()
    }
}

extension SegmentLength: Scalar {
    public func update() {
        guard let xy0 = segment.asWeakStraight.xy0, let xy1 = segment.asWeakStraight.xy1 else {
            length = nil
            return
        }
        length = (xy1 - xy0).norm()
    }
}

