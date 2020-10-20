public protocol PointOnStraight: PointOnCurve {
    associatedtype S: Straight where S.T == T
    var straight: S? { get }
    func position(for length: Length<T>, on norm: Length<T>) -> Position?
}

public extension PointOnStraight {
    func closestPosition(to point: XY<T>) -> Position? {
        guard let straight = straight, let origin = straight.xy0, let vector = straight.vector else { return nil }
        let norm = vector.norm()
        guard let normalizedDX = vector.dx.length / norm, let normalizedDY = vector.dy.length / norm else { return nil }
        let relativePoint = point - origin
        let projectedLength = normalizedDX * relativePoint.dx.length + normalizedDY * relativePoint.dy.length
        return position(for: projectedLength, on: norm)
    }
}
