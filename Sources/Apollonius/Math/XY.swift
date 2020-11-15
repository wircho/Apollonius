import Numerics

infix operator •: MultiplicationPrecedence
infix operator ><: MultiplicationPrecedence

public protocol Coordinate: Dimension {}

public struct X<T: Real & Codable>: Coordinate {
    public let value: T
    public init(value: T) { self.value = value }
}

public struct Y<T: Real & Codable>: Coordinate {
    public let value: T
    public init(value: T) { self.value = value }
}

public struct Length<T: Real & Codable>: Metric {
    public let value: T
    public init(value: T) { self.value = value }
}

public struct Ratio<T: Real & Codable>: Value {
    public let value: T
    public init(value: T) { self.value = value }
}

public typealias DX<T: Real & Codable> = X<T>.Difference
public typealias DY<T: Real & Codable> = Y<T>.Difference

public extension Difference where D: Coordinate {
    var length: Length<T> { return .init(value: value) }
}

public struct XY<T: Real & Codable> {
    public var x: X<T>
    public var y: Y<T>
}

public struct DXY<T: Real & Codable> {
    public var dx: DX<T>
    public var dy: DY<T>
}

public func +<T>(lhs: XY<T>, rhs: DXY<T>) -> XY<T> {
    return .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func +<T>(lhs: DXY<T>, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func -<T>(lhs: XY<T>, rhs: XY<T>) -> DXY<T> {
    return .init(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

public func -<T>(lhs: DXY<T>, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

public func -<T>(lhs: XY<T>, rhs: DXY<T>) -> XY<T> {
    return .init(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

public func *<T>(lhs: T, rhs: DXY<T>) -> DXY<T> {
    return .init(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
}

public func /<T>(lhs: DXY<T>, rhs: T) -> DXY<T>? {
    guard let dx = lhs.dx / rhs, let dy = lhs.dy / rhs else { return nil }
    return DXY<T>(dx: dx, dy: dy)
}

public func •<T>(lhs: DXY<T>, rhs: DXY<T>) -> Squared<Length<T>> {
    return lhs.dx.length * rhs.dx.length + lhs.dy.length * rhs.dy.length
}

public func ><<T>(lhs: DXY<T>, rhs: DXY<T>) -> Squared<Length<T>> {
  return lhs.dx.length * rhs.dy.length - lhs.dy.length * rhs.dx.length
}

public extension Length {
    var asDX: X<T>.Difference { return .init(value: value) }
    var asDY: Y<T>.Difference { return .init(value: value) }
}

public extension DXY {
    func normSquared() -> Squared<Length<T>> {
        return dx.length.squared() + dy.length.squared()
    }
    
    func norm() -> Length<T> {
        return normSquared().squareRoot()!
    }
    
    var rotated90Degrees: DXY {
        return .init(dx: .init(value: -dy.value), dy: .init(value: dx.value))
    }
    
    var angle: Angle<T>? {
        let value = T.atan2(y: dy.value, x: dx.value)
        guard value.isFinite else { return nil }
        return .init(value: value)
    }
}
