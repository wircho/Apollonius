import Numerics

public protocol Shape: AnyObject {
  associatedtype T: Real
  associatedtype Parameters
  associatedtype Value
  var index: Int { get }
  var children: [UnownedShape<T>] { get set }
  var parameters: Parameters { get }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

protocol ShapeInternal: Shape, Simplifiable where Context == CanvasContext {}

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
  
  init<S: Shape>(_ shape: S) where S.T == T {
    self.inner = .init(shape)
    self._children = { [weak shape] in shape!.children }
    self._appendChild = { [weak shape] child in shape!.children.append(child) }
    self._update = { [weak shape] in shape!.update() }
  }
}

extension UnownedShape: UnownedShapeConvertibleInternal {
  public var asUnownedShape: UnownedShape<T> { return self }
}

func ==<S: UnownedShapeConvertible>(lhs: S, rhs: S) -> Bool {
  return lhs.asUnownedShape.inner.object === rhs.asUnownedShape.inner.object
}

func ==<S0: Shape, S1: UnownedShapeConvertibleInternal>(lhs: S0, rhs: S1) -> Bool where S1.ObjectType == S0, S0.T == S1.T {
  return lhs === rhs.asUnownedShape.inner.object
}

func ==<S0: UnownedShapeConvertibleInternal, S1: Shape>(lhs: S0, rhs: S1) -> Bool where S0.ObjectType == S1, S0.T == S1.T {
  return lhs.asUnownedShape.inner.object === rhs
}

extension Counter {
  static var shapes = Counter()
}
