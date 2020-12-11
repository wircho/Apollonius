import Numerics

public protocol GeometricShape: AnyObject {
  associatedtype T: Real & Codable
  associatedtype Parameters
  associatedtype Value
  var parameters: Parameters { get }
  var value: Value? { get }
}
