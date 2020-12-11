import Numerics

typealias DX<T: Real & Codable> = X<T>.Difference
typealias DY<T: Real & Codable> = Y<T>.Difference

extension Difference where D: Coordinate {
    var length: Length<T> { return .init(value: value) }
}

struct DXY<T: Real & Codable> {
    var dx: DX<T>
    var dy: DY<T>
}

extension DXY {
    func normSquared() -> Squared<Length<T>> {
        return dx.length.squared() + dy.length.squared()
    }
    
    func norm() -> Length<T> {
        return normSquared().squareRoot()!
    }
    
    var rotated90Degrees: DXY {
        return .init(dx: .init(value: -dy.value), dy: .init(value: dx.value))
    }
    
    var angle: SimpleAngle<T>? {
        let value = T.atan2(y: dy.value, x: dx.value)
        guard value.isFinite else { return nil }
        return .init(value: value)
    }
}

func +<T>(lhs: XY<T>, rhs: DXY<T>) -> XY<T> {
    return .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

func +<T>(lhs: DXY<T>, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func -<T>(lhs: XY<T>, rhs: XY<T>) -> DXY<T> {
    return .init(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

func -<T>(lhs: DXY<T>, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

func -<T>(lhs: XY<T>, rhs: DXY<T>) -> XY<T> {
    return .init(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

func *<T>(lhs: T, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
}

func /<T>(lhs: DXY<T>, rhs: T) -> DXY<T>? {
    guard let dx = lhs.dx / rhs, let dy = lhs.dy / rhs else { return nil }
    return DXY<T>(dx: dx, dy: dy)
}

func •<T>(lhs: DXY<T>, rhs: DXY<T>) -> Squared<Length<T>> {
    return lhs.dx.length * rhs.dx.length + lhs.dy.length * rhs.dy.length
}

func ><<T>(lhs: DXY<T>, rhs: DXY<T>) -> Squared<Length<T>> {
  return lhs.dx.length * rhs.dy.length - lhs.dy.length * rhs.dx.length
}

