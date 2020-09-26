public protocol Straight: Curve {
    associatedtype Phantom: StraightPhantom
    var xy0: XY<T>? { get }
    var xy1: XY<T>? { get }
}

public extension Straight {
    var vector: DXY<T>? {
        guard let xy0 = xy0, let xy1 = xy1 else { return nil }
        return xy1 - xy0
    }
}
