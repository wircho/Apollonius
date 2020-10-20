import Numerics

public protocol Figure: AnyObject {
  associatedtype T: Real
  associatedtype Parameters
  associatedtype Value
  var children: [UnownedFigure<T>] { get set }
  var parameters: Parameters { get }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

public extension Figure {
  func update() { value = newValue() }
}

// UnownedFigure

import Numerics

public protocol UnownedFigureConvertible {
  associatedtype T: Real
  var asUnownedFigure: UnownedFigure<T> { get }
}

protocol UnownedFigureConvertibleInternal: UnownedFigureConvertible {
  associatedtype ObjectType: AnyObject
  var inner: Unowned<ObjectType> { get }
}

public struct UnownedFigure<T: Real> {
  let _children: () -> [UnownedFigure<T>]
  let _appendChild: (UnownedFigure<T>) -> Void
  let _update: () -> Void
  let inner: Unowned<AnyObject>
  
  public var children: [UnownedFigure]? { return _children() }
  public func append(child: UnownedFigure<T>) { _appendChild(child) }
  public func update() { _update() }
  
  init<F: Figure>(_ figure: F) where F.T == T {
    self.inner = .init(figure)
    self._children = { [weak figure] in figure!.children }
    self._appendChild = { [weak figure] child in figure!.children.append(child) }
    self._update = { [weak figure] in figure!.update() }
  }
}

extension UnownedFigure: UnownedFigureConvertibleInternal {
  public var asUnownedFigure: UnownedFigure<T> { return self }
}

func ==<F0: UnownedFigureConvertible, F1: UnownedFigureConvertible>(lhs: F0, rhs: F1) -> Bool {
  return lhs.asUnownedFigure.inner.object === rhs.asUnownedFigure.inner.object
}

func ==<F0: Figure, F1: UnownedFigureConvertible>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
  return lhs === rhs.asUnownedFigure.inner.object
}

func ==<F0: UnownedFigureConvertible, F1: Figure>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
  return lhs.asUnownedFigure.inner.object === rhs
}
