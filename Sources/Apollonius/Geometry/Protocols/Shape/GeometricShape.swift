import Numerics

protocol GeometricShape: AnyObject, Simplifiable where Context == AnyCanvasContext<T> {
  associatedtype Parameters
  associatedtype T: Real & Codable
  associatedtype Value
  var parameters: Parameters { get }
  init(_ parameters: Parameters)
  var index: Int { get }
  var children: Set<UnownedShape<T>> { get set }
  var parents: Set<UnownedShape<T>> { get set }
  var value: Value? { get set }
  func newValue() -> Value?
}

extension GeometricShape {
  var key: ObjectIdentifier { return .init(self) }
  func update() { value = newValue() }
}

extension Counter {
  static var shapes = Counter()
}
