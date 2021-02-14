import Numerics

extension Geometry {
  final class Circular<T: Real & Codable> {
    var value: Value? = nil
    
    let index = Counter.shapes.newIndex()
    let parameters: CircularParameters<T>
    var children: Set<UnownedShape<T>> = []
    var parents: Set<UnownedShape<T>> = []
    var knownPoints: Set<UnownedPoint<T>> = []
    var endPoints: Set<UnownedPoint<T>> = []
    
    init(_ parameters: CircularParameters<T>) {
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
        setEndPoints(point0, point2)
        slideThrough(point1)
      }
    }
    
    deinit {
      clearAllParenting()
      clearAllPoints()
    }
  }
}
