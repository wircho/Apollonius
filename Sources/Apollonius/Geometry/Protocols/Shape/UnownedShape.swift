import Numerics

struct UnownedShape<T: Real & Codable> {
  let _children: () -> Set<UnownedShape<T>>
  let _removeChild: (UnownedShape<T>) -> Void
  let _removeParent: (UnownedShape<T>) -> Void
  let _update: () -> Void
  let inner: Unowned<AnyObject>
  
  var children: Set<UnownedShape<T>> { return _children() }
  func remove(child: UnownedShape<T>) { _removeChild(child) }
  func remove(parent: UnownedShape<T>) { _removeParent(parent) }
  func update() { _update() }
  
  init<S: GeometricShapeInternal>(_ shape: S) where S.T == T {
    self.inner = .init(shape)
    self._children = { [weak shape] in shape!.children }
    self._removeChild = { [weak shape] child in shape!.children.remove(child) }
    self._removeParent = { [weak shape] parent in shape!.parents.remove(parent) }
    self._update = { [weak shape] in shape!.update() }
  }
}

extension UnownedShape: Hashable {
  func hash(into hasher: inout Hasher) {
    inner.identifier.hash(into: &hasher)
  }
}
