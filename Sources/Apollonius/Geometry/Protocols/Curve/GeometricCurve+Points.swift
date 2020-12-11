extension GeometricCurveInternal {
  func slideThrough(_ singlePoint: Geometry.Point<T>) {
    knownPoints.insert(.init(singlePoint))
    singlePoint.knownCurves.insert(.init(self))
  }
  
  func slideThrough(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>) {
    slideThrough(point0)
    slideThrough(point1)
  }
  
  func slideThrough(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>, _ point2: Geometry.Point<T>) {
    slideThrough(point0)
    slideThrough(point1)
    slideThrough(point2)
  }
  
  func slideThrough(_ singlePoint: UnownedPoint<T>) {
    slideThrough(singlePoint.inner.object)
  }
  
  func slideThrough(_ point0: UnownedPoint<T>, _ point1: UnownedPoint<T>) {
    slideThrough(point0)
    slideThrough(point1)
  }
  
  func slideThrough(_ point0: UnownedPoint<T>, _ point1: UnownedPoint<T>, _ point2: UnownedPoint<T>) {
    slideThrough(point0)
    slideThrough(point1)
    slideThrough(point2)
  }
  
  func clearAllPoints() {
    let unowned = UnownedCurve(self)
    for point in knownPoints { point.inner.object.knownCurves.remove(unowned) }
  }
}
