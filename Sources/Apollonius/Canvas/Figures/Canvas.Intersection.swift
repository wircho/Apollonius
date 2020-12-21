import Foundation
import Numerics

extension Canvas {
  final class Intersection: UnstyledFigureProtocol {
    let storage: FigureProtocolStorage<Geometry.Intersection<T>, IntersectionStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Intersection<T>, IntersectionStyle, FigureMeta>) {
      self.storage = storage
    }
    
    var key: ObjectIdentifier { storage.shape.key }
  }
}

// Internal unsafe methods (no sorting, checking for existing figures, or adding to items)
internal extension Canvas {
  func intersectionItemBetween(_ straight: Geometry.Straight<T>, _ circular: Geometry.Circular<T>) -> Intersection {
    let shape = Geometry.Intersection.between(straight, circular)
    return Intersection(shape, style: .init(), meta: .init(), canvas: self)
  }
  
  func intersectionItemBetween(_ circular0: Geometry.Circular<T>, _ circular1: Geometry.Circular<T>) -> Intersection {
    let shape = Geometry.Intersection.between(circular0, circular1)
    return Intersection(shape, style: .init(), meta: .init(), canvas: self)
  }
}
