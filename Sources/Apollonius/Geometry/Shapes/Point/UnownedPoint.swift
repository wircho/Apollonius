import Numerics

public struct UnownedPoint<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Point<T>>
  public let asUnownedShape: UnownedShape<T>
  
  let _removeKnownCurve: (UnownedCurve<T>) -> Void
  
  func remove(knownCurve: UnownedCurve<T>) { _removeKnownCurve(knownCurve) }
  
  init(_ point: Geometry.Point<T>) {
    inner = .init(point)
    asUnownedShape = .init(point)
    _removeKnownCurve = { [weak point] curve in point!.knownCurves.remove(curve) }
  }
}

extension UnownedPoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    inner.identifier.hash(into: &hasher)
  }
}
