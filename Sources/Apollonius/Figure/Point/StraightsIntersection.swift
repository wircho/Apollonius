public final class StraightsIntersection<T, S0: Straight, S1: Straight> where S0.T == T, S1.T == T {
    let straight0: Weak<S0>
    let straight1: Weak<S1>
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(straight0: S0, straight1: S1) {
        self.straight0 = Weak(straight0)
        self.straight1 = Weak(straight1)
        straight0.children.append(.init(self))
        straight1.children.append(.init(self))
        straight0.knownPoints.append(.init(self))
        straight1.knownPoints.append(.init(self))
        self.update()
    }
}

extension StraightsIntersection: Point {
    public func update() {
        guard let straight0 = straight0.object,
            let straight1 = straight1.object,
            let origin0 = straight0.xy0,
            let origin1 = straight1.xy1,
            let vector0 = straight0.vector,
            let vector1 = straight1.vector else {
            xy = nil
            return
        }
        let originDifference = origin1 - origin0
        let numerator0 = originDifference.dx * vector1.dy - vector1.dx * originDifference.dy
        let numerator1 = vector0.dx * originDifference.dy - originDifference.dx * vector0.dy
        let denominator = vector0.dx * vector1.dy - vector1.dx * vector0.dy
        guard let value0 = numerator0 / denominator, let value1 = numerator1 / denominator else {
            xy = nil
            return
        }
        guard S0.Phantom.containsNormalizedValue(value0),
            S1.Phantom.containsNormalizedValue(value1) else {
            xy = nil
            return
        }
        xy = origin0 + value0 * vector0
    }
}
