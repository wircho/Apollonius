import Numerics

public protocol Curve: Shape {
  var knownPoints: [UnownedPoint<T>] { get set }
}

public struct UnownedCurve<T: Real & Codable>: UnownedShapeConvertibleInternal {
  public let asUnownedShape: UnownedShape<T>
  // Computed
  var inner: Unowned<AnyObject> { return asUnownedShape.inner }
  
  init<C: Curve>(_ curve: C) where C.T == T {
    asUnownedShape = .init(curve)
  }
}
