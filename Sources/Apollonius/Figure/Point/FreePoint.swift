import Numerics

public final class FreePoint<T: Real> {
    public var children: [AnyWeakFigure<T>] = []
    public private(set) var xy: XY<T>?
    
    public init(x: T, y: T) {
        xy = .init(x: .init(value: x), y: .init(value: y))
    }
    
    public init(x: X<T>, y: Y<T>) {
        xy = .init(x: x, y: y)
    }
    
    public init(xy: XY<T>) {
        self.xy = xy
    }
    
    public func move(to xy: XY<T>) {
        self.xy = xy
    }
}

extension FreePoint: FreeFigure, Point {
    public func update() {}
}
