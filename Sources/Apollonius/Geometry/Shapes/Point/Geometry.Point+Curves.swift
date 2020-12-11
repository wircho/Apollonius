extension Geometry.Point {
  func layOn<C: GeometricCurveInternal>(_ singleCurve: C) where C.T == T {
    knownCurves.insert(.init(singleCurve))
    singleCurve.knownPoints.insert(.init(self))
  }
  
  func layOn<C0: GeometricCurveInternal, C1: GeometricCurveInternal>(_ curve0: C0, _ curve1: C1) where C0.T == T, C1.T == T {
    layOn(curve0)
    layOn(curve1)
  }
  
  func layOn<C: UnownedShapeConvertibleInternal>(_ singleCurve: C) where C.ObjectType: GeometricCurveInternal, C.T == T, C.ObjectType.T == T {
    layOn(singleCurve.inner.object)
  }
  
  func layOn<C0: UnownedShapeConvertibleInternal, C1: UnownedShapeConvertibleInternal>(_ curve0: C0, _ curve1: C1) where C0.ObjectType: GeometricCurveInternal, C1.ObjectType: GeometricCurveInternal, C0.T == T, C1.T == T, C0.ObjectType.T == T, C1.ObjectType.T == T {
    layOn(curve0)
    layOn(curve1)
  }
  
  func clearAllCurves() {
    let unowned = UnownedPoint(self)
    for curve in knownCurves { curve.remove(knownPoint: unowned) }
  }
}

