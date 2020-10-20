public typealias ParallelLine<T, P: Point, S: Straight> = DirectedLine<T, Parallel, P, S> where P.T == T, S.T == T

public enum Parallel: DirectedLinePhantom {
    public static func direction<S: Straight>(to straight: S) -> DXY<S.T>? {
        return straight.vector
    }
}
