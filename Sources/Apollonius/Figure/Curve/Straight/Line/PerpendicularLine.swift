public typealias PerpendicularLine<T, P: Point, S: Straight> = DirectedLine<T, Perpendicular, P, S> where P.T == T, S.T == T

public enum Perpendicular: DirectedLinePhantom {
    public static func direction<S: Straight>(to straight: S) -> DXY<S.T>? {
        return straight.vector?.rotated90Degrees
    }
}
