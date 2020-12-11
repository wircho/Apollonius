protocol GeometricShapeInternal: GeometricShape, Simplifiable where Context == CanvasContext {
  associatedtype Parameters
  var parameters: Parameters { get }
  init(_ parameters: Parameters)
  var index: Int { get }
  var children: Set<UnownedShape<T>> { get set }
  var parents: Set<UnownedShape<T>> { get set }
  var value: Value? { get set }
  func newValue() -> Value?
}

extension GeometricShapeInternal {
  func update() { value = newValue() }
}

extension Counter {
  static var shapes = Counter()
}
