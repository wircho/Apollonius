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
}

extension GeometricCurveInternal {
  func setEndPoint(_ singlePoint: Geometry.Point<T>) {
    slideThrough(singlePoint)
    endPoints.insert(.init(singlePoint))
    singlePoint.endingCurves.insert(.init(self))
  }
  
  func setEndPoints(_ point0: Geometry.Point<T>, _ point1: Geometry.Point<T>) {
    setEndPoint(point0)
    setEndPoint(point1)
  }
  
  func setEndPoint(_ singlePoint: UnownedPoint<T>) {
    setEndPoint(singlePoint.inner.object)
  }
  
  func setEndPoints(_ point0: UnownedPoint<T>, _ point1: UnownedPoint<T>) {
    setEndPoint(point0)
    setEndPoint(point1)
  }
}


extension GeometricCurveInternal {
  func clearAllPoints() {
    let unowned = UnownedCurve(self)
    for point in knownPoints {
      point.inner.object.knownCurves.remove(unowned)
      point.inner.object.endingCurves.remove(unowned)
    }
  }
}
