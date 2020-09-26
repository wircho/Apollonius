public protocol Figure: AnyObject {
    associatedtype T: FloatingPoint
    var children: [AnyWeakFigure<T>] { get set }
    func update()
}


