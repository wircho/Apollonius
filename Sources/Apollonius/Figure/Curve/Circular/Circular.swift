public protocol Circular: Curve {
    var centerXY: XY<T>? { get }
    var radius: Length<T>? { get }
    func contains(angle: Angle<T>) -> Bool
}
