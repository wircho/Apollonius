import Numerics

public protocol GeometricShape: AnyObject {
  associatedtype T: Real & Codable
  associatedtype Parameters
  associatedtype Value
  var index: Int { get }
  var children: Set<UnownedShape<T>> { get set }
  var parents: Set<UnownedShape<T>> { get set }
  var parameters: Parameters { get }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

public extension GeometricShape {
  func update() { value = newValue() }
}

extension Counter {
  static var shapes = Counter()
}
