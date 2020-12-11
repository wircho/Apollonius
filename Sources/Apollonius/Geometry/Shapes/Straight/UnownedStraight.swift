import Numerics

public struct UnownedStraight<T: Real & Codable>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Straight<T>>
  public let asUnownedCurve: UnownedCurve<T>
  // Computed
  public var asUnownedShape: UnownedShape<T> { return asUnownedCurve.asUnownedShape }
  
  init(_ straight: Geometry.Straight<T>) {
    inner = .init(straight)
    asUnownedCurve = .init(straight)
  }
}

