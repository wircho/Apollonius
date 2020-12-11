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

public struct XY<T: Real & Codable> {
    public var x: X<T>
    public var y: Y<T>
}

public extension Length {
    var asDX: X<T>.Difference { return .init(value: value) }
    var asDY: Y<T>.Difference { return .init(value: value) }
}
