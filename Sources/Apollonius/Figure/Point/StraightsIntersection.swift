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
        guard let xy00 = straight0.object?.xy0,
            let xy01 = straight0.object?.xy1,
            let xy10 = straight1.object?.xy0,
            let xy11 = straight1.object?.xy1 else {
            xy = nil
            return
        }
        let x00 = xy00.x
        let y00 = xy00.y
        let x01 = xy01.x
        let y01 = xy01.y
        let x10 = xy10.x
        let y10 = xy10.y
        let x11 = xy11.x
        let y11 = xy11.y
        let dx_0 = x00 - x10
        let dx0_ = x00 - x01
        // unused: let dx_1 = x01 - x11
        let dx1_ = x10 - x11
        let dy_0 = y00 - y10
        let dy0_ = y00 - y01
        // unused: let dy_1 = y01 - y11
        let dy1_ = y10 - y11
        let tn = dx_0 * dy1_ - dx1_ * dy_0
        let td = dx0_ * dy1_ - dx1_ * dy0_
        let un = dx0_ * dy_0 - dx_0 * dy0_
        let ud = dx0_ * dy1_ - dx1_ * dy0_
//        guard let t = tn / td, let u = -un / ud else {
//            xy = nil
//            return
//        }
        // TODO: NOTHING WORKS NOW, REVERT TO HAVING straight phantoms without asssociated types?
    }
}
