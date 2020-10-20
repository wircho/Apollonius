public class PointOnLine<T, L: Line> where L.T == T {
    let line: Weak<L>
    public var straight: L? { return line.object }
    public var position: Length<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownCurves: [AnyWeakCurve<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(line: L, position: Length<T>) {
        self.line = Weak(line)
        self.position = position
        self.applyRelationships()
        self.update()
    }
}

extension PointOnLine: PointOnStraight {
    public func position(for length: Length<T>, on _: Length<T>) -> Length<T>? {
        return length
    }
    
    public func update() {
        guard let line = line.object, let origin = line.xy0, let angle = line.vector?.angle else {
            xy = nil
            return
        }
        xy = origin + position.dxy(at: angle)
    }
}

