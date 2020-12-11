import Numerics

public struct UnownedCurve<T: Real & Codable>: UnownedShapeConvertibleInternal {
  public let asUnownedShape: UnownedShape<T>
  var inner: Unowned<AnyObject> { return asUnownedShape.inner }
  let _removeKnownPoint: (UnownedPoint<T>) -> Void
  func remove(knownPoint: UnownedPoint<T>) { _removeKnownPoint(knownPoint) }
  
  init<C: GeometricCurveInternal>(_ curve: C) where C.T == T {
    asUnownedShape = .init(curve)
    _removeKnownPoint = { [weak curve] point in curve!.knownPoints.remove(point) }
  }
}

extension UnownedCurve: Hashable {
  public func hash(into hasher: inout Hasher) {
    inner.identifier.hash(into: &hasher)
  }
}
