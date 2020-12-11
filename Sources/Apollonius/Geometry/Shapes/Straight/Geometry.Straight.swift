import Numerics

public extension Geometry {
  
  final class Straight<T: Real & Codable> {
    
    public let index = Counter.shapes.newIndex()
    public var value: Value? = nil
    public let parameters: StraightParameters<T>
    public var children: Set<UnownedShape<T>> = []
    public var parents: Set<UnownedShape<T>> = []
    public var knownPoints: Set<UnownedPoint<T>> = []
    
    public init(_ parameters: StraightParameters<T>) {
      self.parameters = parameters
      self.update()
      switch parameters.definition {
      case let ._between(origin, tip):
        makeChildOf(origin, tip)
        slideThrough(origin, tip)
      case let ._directed(_, origin, other):
        makeChildOf(origin, other)
        slideThrough(origin)
      }
      update()
    }
    
    deinit {
      clearAllParenting()
      clearAllPoints()
    }
  }
}
