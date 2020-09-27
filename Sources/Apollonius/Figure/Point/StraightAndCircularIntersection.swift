public enum StraightAndCircularIntersectionIndex {
    case positive, negative
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
        guard let vector = straight.object?.vector,
            let origin = straight.object?.xy0,
            let circular = circular.object,
            let center = circular.centerXY,
            let radius = circular.radius else {
            xy = nil
            return
        }
        let centerToOrigin = origin - center
        let a = vector.normSquared()
        let b = 2 * (vector • centerToOrigin)
        let c = centerToOrigin.normSquared() - radius.squared()
        let discriminant = b.squared() - 4 * (a * c)
        guard let discriminantSquareRoot = discriminant.squareRoot() else {
            xy = nil
            return
        }
        let numerator: Squared<Length<T>>
        switch index {
        case .positive: numerator = -b + discriminantSquareRoot
        case .negative: numerator = -b - discriminantSquareRoot
        }
        guard let t = numerator / (2 * a), S.Phantom.contains(normalizedValue: t) else {
            xy = nil
            return
        }
        let possibleXY = origin + t * vector
        let angle = (possibleXY - center).angle
        guard circular.contains(angle: angle) else {
            xy = nil
            return
        }
        xy = possibleXY
    }
}
