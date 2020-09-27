import Numerics

public protocol Figure: AnyObject {
    associatedtype T: Real
    var children: [AnyWeakFigure<T>] { get set }
    func update()
}


