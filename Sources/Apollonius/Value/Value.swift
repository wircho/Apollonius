public protocol Value {
    associatedtype T: FloatingPoint
    var value: T { get set }
    init(value: T)
}
