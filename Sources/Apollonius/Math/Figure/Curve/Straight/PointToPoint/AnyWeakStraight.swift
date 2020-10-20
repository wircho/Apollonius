import Numerics

public struct AnyWeakStraight<T: Real>: AnyWeakFigureConvertible {
    let _xy0: () -> XY<T>?
    let _xy1: () -> XY<T>?
    public let asWeakCurve: AnyWeakCurve<T>
    
    public var xy0: XY<T>? { return _xy0() }
    public var xy1: XY<T>? { return _xy1() }
    public var asWeakFigure: AnyWeakFigure<T> { return asWeakCurve.asWeakFigure }
    
    init<S: Straight>(_ straight: S?) where S.T == T {
        _xy0 = { [weak straight] in straight!.xy0 }
        _xy1 = { [weak straight] in straight!.xy1 }
        asWeakCurve = .init(straight)
    }
}

