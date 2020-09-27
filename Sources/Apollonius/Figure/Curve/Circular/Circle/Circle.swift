public protocol Circle: Circular {}

public extension Circle {
    func contains(angle: Angle<T>) -> Bool { return true }
}
