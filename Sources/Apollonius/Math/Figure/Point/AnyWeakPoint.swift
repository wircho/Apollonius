import Numerics

public struct AnyWeakPoint<T: Real>: AnyWeakFigureConvertible {
    let _xy: () -> XY<T>?
    let _knownCurves: () -> [AnyWeakCurve<T>]
    let _appendKnownCurve: (AnyWeakCurve<T>) -> Void
    public let asWeakFigure: AnyWeakFigure<T>
    
    public var xy: XY<T>? { return _xy() }
    public var knwonCurves: [AnyWeakCurve<T>] { return _knownCurves() }
    public func append(knownCurve: AnyWeakCurve<T>) { _appendKnownCurve(knownCurve) }
    
    init<P: Point>(_ point: P?) where P.T == T {
        _xy = { [weak point] in point!.xy }
        _knownCurves = { [weak point] in point!.knownCurves }
        _appendKnownCurve = { [weak point] curve in point!.knownCurves.append(curve) }
        asWeakFigure = .init(point)
    }
    
    init<P: Point>(_ weakPoint: Weak<P>) where P.T == T {
        self.init(weakPoint.object)
    }
}
