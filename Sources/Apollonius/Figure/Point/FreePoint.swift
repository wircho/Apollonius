public final class FreePoint<T: FloatingPoint>: FreeFigure, Point {
    private var _xy: XY<T>
    public var children: [AnyWeakFigure<T>] = []
    public var xy: XY<T>? { return _xy }
    
    public init(x: T, y: T) {
        self._xy = .init(x: .init(value: x), y: .init(value: y))
    }
    
    public init(x: X<T>, y: Y<T>) {
        self._xy = .init(x: x, y: y)
    }
    
    public init(xy: XY<T>) {
        self._xy = xy
    }
    
    public func update() {}
}
