import Numerics

public struct AnyWeakPoint<T: Real>: AnyWeakFigureConvertible {
    let _xy: () -> XY<T>?
    
    public var xy: XY<T>? { return _xy() }
    public let asWeakFigure: AnyWeakFigure<T>
    
    init<P: Point>(_ point: P) where P.T == T {
        _xy = { [weak point] in point?.xy }
        asWeakFigure = .init(point)
    }
}

