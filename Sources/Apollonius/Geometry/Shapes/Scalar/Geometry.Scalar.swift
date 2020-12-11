import Numerics

public extension Geometry {
  
  final class Scalar<T: Real & Codable> {
    public let index = Counter.shapes.newIndex()
    public var value: Length<T>? = nil
    public let parameters: ScalarParameters<T>
    public var children: Set<UnownedShape<T>> = []
    public var parents: Set<UnownedShape<T>> = []
    
    public init(_ parameters: ScalarParameters<T>) {
      self.parameters = parameters
      self.update()
      switch parameters {
      case let ._distance(point0, point1):
        makeChildOf(point0, point1)
      }
    }
    
    deinit {
      clearAllParenting()
    }
  }
}
