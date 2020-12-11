import Numerics

public extension Geometry {
  
  final class Intersection<T: Real & Codable> {
    
    public let index = Counter.shapes.newIndex()
    public var value: Value? = nil
    public let parameters: IntersectionParameters<T>
    public var children: Set<UnownedShape<T>> = [] {
      didSet {
        if oldValue.count > 0 && children.count == 0 {
          onNoChildren?()
        }
      }
    }
    public var parents: Set<UnownedShape<T>> = []
    var onNoChildren: (() -> Void)? = nil
    
    public init(_ parameters: IntersectionParameters<T>) {
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
