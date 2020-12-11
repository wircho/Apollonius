protocol GeometricShapeInternal: GeometricShape, Simplifiable where Context == CanvasContext {
  var index: Int { get }
  var children: Set<UnownedShape<T>> { get set }
  var parents: Set<UnownedShape<T>> { get set }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

extension GeometricShapeInternal {
  func update() { value = newValue() }
}

extension Counter {
  static var shapes = Counter()
}
