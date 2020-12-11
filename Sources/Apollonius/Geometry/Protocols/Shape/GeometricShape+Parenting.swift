extension GeometricShapeInternal {
  func makeChildOf<P: GeometricShapeInternal>(_ singleParent: P) where P.T == T {
    parents.insert(.init(singleParent))
    singleParent.children.insert(.init(self))
  }
  
  func makeChildOf<P0: GeometricShapeInternal, P1: GeometricShapeInternal>(_ parent0: P0, _ parent1: P1) where P0.T == T, P1.T == T {
    makeChildOf(parent0)
    makeChildOf(parent1)
  }
  
  func makeChildOf<P0: GeometricShapeInternal, P1: GeometricShapeInternal, P2: GeometricShapeInternal>(_ parent0: P0, _ parent1: P1, _ parent2: P2) where P0.T == T, P1.T == T, P2.T == T {
    makeChildOf(parent0)
    makeChildOf(parent1)
    makeChildOf(parent2)
  }
  
  func makeChildOf<P: UnownedShapeConvertibleInternal>(_ singleParent: P) where P.ObjectType: GeometricShapeInternal, P.T == T, P.ObjectType.T == T {
    makeChildOf(singleParent.inner.object)
  }
  
  func makeChildOf<P0: UnownedShapeConvertibleInternal, P1: UnownedShapeConvertibleInternal>(_ parent0: P0, _ parent1: P1) where P0.ObjectType: GeometricShapeInternal, P1.ObjectType: GeometricShapeInternal, P0.T == T, P1.T == T, P0.ObjectType.T == T, P1.ObjectType.T == T {
    makeChildOf(parent0)
    makeChildOf(parent1)
  }
  
  func makeChildOf<P0: UnownedShapeConvertibleInternal, P1: UnownedShapeConvertibleInternal, P2: UnownedShapeConvertibleInternal>(_ parent0: P0, _ parent1: P1, _ parent2: P2) where P0.ObjectType: GeometricShapeInternal, P1.ObjectType: GeometricShapeInternal, P2.ObjectType: GeometricShapeInternal, P0.T == T, P1.T == T, P2.T == T, P0.ObjectType.T == T, P1.ObjectType.T == T, P2.ObjectType.T == T {
    makeChildOf(parent0)
    makeChildOf(parent1)
    makeChildOf(parent2)
  }
  
  func clearAllParenting() {
    let unowned = UnownedShape(self)
    for child in children { child.remove(parent: unowned) }
    for parent in parents { parent.remove(child: unowned) }
  }
}
