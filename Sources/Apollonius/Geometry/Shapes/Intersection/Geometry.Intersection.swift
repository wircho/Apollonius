import Numerics

extension Geometry {
  
  final class Intersection<T: Real & Codable> {
    var value: Value? = nil
    
    let index = Counter.shapes.newIndex()
    let parameters: IntersectionParameters<T>
    var children: Set<UnownedShape<T>> = [] {
      didSet {
        if oldValue.count > 0 && children.count == 0 {
          onNoChildren?()
        }
      }
    }
    var parents: Set<UnownedShape<T>> = []
    var onNoChildren: (() -> Void)? = nil
    
    init(_ parameters: IntersectionParameters<T>) {
      self.parameters = parameters
      self.update()
      switch parameters {
      case let ._straightCircular(straight, circular):
        makeChildOf(straight, circular)
      case let ._twoCirculars(circular0, circular1):
        makeChildOf(circular0, circular1)
      }
    }
    
    deinit {
      clearAllParenting()
    }
  }
}
