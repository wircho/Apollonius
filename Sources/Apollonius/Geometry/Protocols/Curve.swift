import Numerics

public protocol Curve: Figure {
  var knownPoints: [UnownedPoint<T>] { get set }
}

public struct UnownedCurve<T: Real>: UnownedFigureConvertibleInternal {
  public let asUnownedFigure: UnownedFigure<T>
  // Computed
  var inner: Unowned<AnyObject> { return asUnownedFigure.inner }
  
  init<C: Curve>(_ curve: C) where C.T == T {
    asUnownedFigure = .init(curve)
  }
}
