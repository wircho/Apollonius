import Numerics

struct UnownedCurve<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let asUnownedShape: UnownedShape<T>
  var inner: Unowned<AnyObject> { return asUnownedShape.inner }
  let _removeKnownPoint: (UnownedPoint<T>) -> Void
  let _removeEndPoint: (UnownedPoint<T>) -> Void
  func remove(knownPoint: UnownedPoint<T>) { _removeKnownPoint(knownPoint) }
  func remove(endPoint: UnownedPoint<T>) { _removeEndPoint(endPoint) }
  
  init<C: GeometricCurveInternal>(_ curve: C) where C.T == T {
    asUnownedShape = .init(curve)
    _removeKnownPoint = { [weak curve] point in curve!.knownPoints.remove(point) }
    _removeEndPoint = { [weak curve] point in curve!.endPoints.remove(point) }
  }
}

extension UnownedCurve: Hashable {
  func hash(into hasher: inout Hasher) {
    inner.identifier.hash(into: &hasher)
  }
}
