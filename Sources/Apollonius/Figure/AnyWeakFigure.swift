import Numerics

public protocol AnyWeakFigureConvertible {
    associatedtype T: Real
    var asWeakFigure: AnyWeakFigure<T> { get }
}

public struct AnyWeakFigure<T: Real> {
    let _children: () -> [AnyWeakFigure<T>]?
    let _update: () -> Void
    weak var object: AnyObject?
    
    public var children: [AnyWeakFigure]? { return _children() }
    public func update() { _update() }
    
    init<F: Figure>(_ figure: F) where F.T == T {
        self.object = figure
        self._children = { [weak figure] in figure?.children }
        self._update = { [weak figure] in figure?.update() }
    }
}

extension AnyWeakFigure: AnyWeakFigureConvertible {
    public var asWeakFigure: AnyWeakFigure<T> { return self }
}

func ==<F0: AnyWeakFigureConvertible, F1: AnyWeakFigureConvertible>(lhs: F0, rhs: F1) -> Bool {
    return lhs.asWeakFigure.object === rhs.asWeakFigure.object
}

func ==<F0: Figure, F1: AnyWeakFigureConvertible>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
    return lhs === rhs.asWeakFigure.object
}

func ==<F0: AnyWeakFigureConvertible, F1: Figure>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
    return lhs.asWeakFigure.object === rhs
}
