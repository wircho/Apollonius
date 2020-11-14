import Numerics

public protocol Shape: AnyObject, RepresentableToProxy where Proxy: Codable {
  associatedtype T: Real & Codable
  associatedtype Parameters
  associatedtype Value
  var index: Int { get }
  var children: [UnownedShape<T>] { get set }
  var parameters: Parameters { get }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

public extension Shape {
  func update() { value = newValue() }
}

public protocol UnownedShapeConvertible {
  associatedtype T: Real
  var asUnownedShape: UnownedShape<T> { get }
}

protocol UnownedShapeConvertibleInternal: UnownedShapeConvertible {
  associatedtype ObjectType: AnyObject
  var inner: Unowned<ObjectType> { get }
}

public struct UnownedShape<T: Real> {
  let _children: () -> [UnownedShape<T>]
  let _appendChild: (UnownedShape<T>) -> Void
  let _update: () -> Void
  let inner: Unowned<AnyObject>
  
  public var children: [UnownedShape]? { return _children() }
  public func append(child: UnownedShape<T>) { _appendChild(child) }
  public func update() { _update() }
  
  init<F: Shape>(_ shape: F) where F.T == T {
    self.inner = .init(shape)
    self._children = { [weak shape] in shape!.children }
    self._appendChild = { [weak shape] child in shape!.children.append(child) }
    self._update = { [weak shape] in shape!.update() }
  }
}

extension UnownedShape: UnownedShapeConvertibleInternal {
  public var asUnownedShape: UnownedShape<T> { return self }
}

func ==<F: UnownedShapeConvertible>(lhs: F, rhs: F) -> Bool {
  return lhs.asUnownedShape.inner.object === rhs.asUnownedShape.inner.object
}

func ==<F0: Shape, F1: UnownedShapeConvertibleInternal>(lhs: F0, rhs: F1) -> Bool where F1.ObjectType == F0, F0.T == F1.T {
  return lhs === rhs.asUnownedShape.inner.object
}

func ==<F0: UnownedShapeConvertibleInternal, F1: Shape>(lhs: F0, rhs: F1) -> Bool where F0.ObjectType == F1, F0.T == F1.T {
  return lhs.asUnownedShape.inner.object === rhs
}

extension Counter {
  static var shapeIndex = Counter()
  static var shapeKey = Counter()
}

public struct ShapeKey: Hashable {
  let value: String
  static var dictionary: [ObjectIdentifier: ShapeKey] = [:]
  
  init<S: AnyObject>(unsafelyWithObject shape: S) {
    value = String(Counter.shapeKey.newIndex())
    ShapeKey.dictionary[ObjectIdentifier(shape)] = self
  }
  
  init<S: Shape>(shape: S) {
    self.init(unsafelyWithObject: shape)
  }
  
  init(value: String) {
    self.value = value
  }
}

extension Shape {
  var key: ShapeKey {
    return ShapeKey.dictionary[ObjectIdentifier(self)] ?? ShapeKey(shape: self)
  }
}

extension UnownedShapeConvertibleInternal {
  var key: ShapeKey {
    return ShapeKey.dictionary[ObjectIdentifier(inner.object)] ?? ShapeKey(unsafelyWithObject: inner.object)
  }
}
