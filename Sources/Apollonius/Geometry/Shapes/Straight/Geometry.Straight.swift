import Numerics

extension Geometry {
  
  final class Straight<T: Real & Codable> {
    var value: Value? = nil
    
    let index = Counter.shapes.newIndex()
    let parameters: StraightParameters<T>
    var children: Set<UnownedShape<T>> = []
    var parents: Set<UnownedShape<T>> = []
    var knownPoints: Set<UnownedPoint<T>> = []
    
    init(_ parameters: StraightParameters<T>) {
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
