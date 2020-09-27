public enum StraightAndCircularIntersectionIndex {
    case first, second
}

public final class StraightAndCircularIntersection<T, S: Straight, C: Circular> where S.T == T, C.T == T {
    let straight: Weak<S>
    let circular: Weak<C>
    let index: StraightAndCircularIntersectionIndex
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(straight: S, circular: C, index: StraightAndCircularIntersectionIndex) {
        self.straight = Weak(straight)
        self.circular = Weak(circular)
        self.index = index
        straight.children.append(.init(self))
        circular.children.append(.init(self))
        straight.knownPoints.append(.init(self))
        circular.knownPoints.append(.init(self))
        self.update()
    }
}

extension StraightAndCircularIntersection: Point {
    public func update() {
        #warning("Implement")
    }
}
