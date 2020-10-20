public class PointOnRay<T, R: Ray> where R.T == T {
    let ray: Weak<R>
    public var straight: R? { return ray.object }
    public var position: Length<T>
    public var children: [AnyWeakFigure<T>] = []
    public var knownCurves: [AnyWeakCurve<T>] = []
    public private(set) var xy: XY<T>? = nil
    
    public init(ray: R, position: Length<T>) {
        self.ray = Weak(ray)
        self.position = position
        self.applyRelationships()
        self.update()
    }
}

extension PointOnRay: PointOnStraight {
    public func position(for length: Length<T>, on _: Length<T>) -> Length<T>? {
        guard length.value >= 0 else { return .init(value: 0) }
        return length
    }
    
    public func update() {
        guard let ray = ray.object, let origin = ray.xy0, let angle = ray.vector?.angle else {
            xy = nil
            return
        }
        xy = origin + position.dxy(at: angle)
    }
}
