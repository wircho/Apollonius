public protocol DirectedLinePhantom {
    static func direction<S: Straight>(to straight: S) -> DXY<S.T>?
}
