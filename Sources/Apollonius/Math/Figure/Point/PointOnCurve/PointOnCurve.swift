public protocol PointOnCurve: Point {
    associatedtype Position
    var position: Position { get set }
    func closestPosition(to point: XY<T>) -> Position?
}
