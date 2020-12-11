import Numerics

public extension Geometry {
  final class Circular<T: Real & Codable> {
    public struct Value {
      public let center: XY<T>
      public let radius: Length<T>
      public let interval: AngleInterval<T>?
    }
    
    public let index = Counter.shapes.newIndex()
    public var value: Value? = nil
    public let parameters: CircularParameters<T>
    public var children: Set<UnownedShape<T>> = []
    public var parents: Set<UnownedShape<T>> = []
    public var knownPoints: Set<UnownedPoint<T>> = []
    
    public init(_ parameters: CircularParameters<T>) {
      self.parameters = parameters
      self.update()
      switch parameters {
      case let ._between(center, tip):
        makeChildOf(center, tip)
        slideThrough(tip)
      case let ._with(center, radius):
        makeChildOf(center, radius)
      case let ._circumcircle(point0, point1, point2):
        makeChildOf(point0, point1, point2)
        slideThrough(point0, point1, point2)
      case let ._arc(point0, point1, point2):
        makeChildOf(point0, point1, point2)
        slideThrough(point0, point1, point2)
      }
    }
    
    deinit {
      clearAllParenting()
      clearAllPoints()
    }
  }
}
