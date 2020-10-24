public protocol Shape {
    associatedtype F: Figure
    associatedtype S
    var figure: F { get }
    var style: S { get set }
}

