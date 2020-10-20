import Numerics

public struct AnyWeakSegment<T: Real>: AnyWeakFigureConvertible {
    public let asWeakStraight: AnyWeakStraight<T>
    public var asWeakFigure: AnyWeakFigure<T> { return asWeakStraight.asWeakFigure }
    
    init<S: Segment>(_ segment: S?) where S.T == T {
        asWeakStraight = .init(segment)
    }
}

