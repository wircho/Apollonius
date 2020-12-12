import Numerics

public protocol GeometricShape: AnyObject {
  associatedtype T: Real & Codable
  associatedtype Value
  var value: Value? { get }
}

extension GeometricShape {
  var key: ObjectIdentifier { return .init(self) }
}
