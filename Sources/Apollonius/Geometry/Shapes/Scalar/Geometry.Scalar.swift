import Numerics

public extension Geometry {
  
  final class Scalar<T: Real & Codable> {
    var value: Length<T>? = nil
    
    let index = Counter.shapes.newIndex()
    let parameters: ScalarParameters<T>
    var children: Set<UnownedShape<T>> = []
    var parents: Set<UnownedShape<T>> = []
    
    init(_ parameters: ScalarParameters<T>) {
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
