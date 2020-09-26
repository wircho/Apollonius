public final class DirectedLine<T, DirectionPhantom: DirectedLinePhantom, P: Point, S: Straight> where P.T == T, S.T == T {
    let point: Weak<P>
    let straight: Weak<S>
    public var children: [AnyWeakFigure<T>] = []
    public let knownPoints: [AnyWeakPoint<T>]
    public private(set) var xy0: XY<T>? = nil
    public private(set) var xy1: XY<T>? = nil
    
    public init(point: P, straight: S) {
        self.point = Weak(point)
        self.straight = Weak(straight)
        self.knownPoints = [AnyWeakPoint(point)]
        point.children.append(.init(self))
        straight.children.append(.init(self))
        self.update()
    }
}

extension DirectedLine: Line {
    public func update() {
        xy0 = point.object?.xy
        guard let xy0 = xy0, let straight = straight.object, let direction = DirectionPhantom.direction(to: straight) else {
            xy1 = nil
            return
        }
        xy1 = xy0 + direction
    }
}
