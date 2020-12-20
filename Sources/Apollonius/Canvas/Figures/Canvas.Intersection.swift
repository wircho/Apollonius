import Foundation
import Numerics

extension Canvas {
  final class Intersection: UnstyledFigureProtocol {
    let storage: FigureProtocolStorage<Geometry.Intersection<T>, IntersectionStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Intersection<T>, IntersectionStyle, FigureMeta>) {
      self.storage = storage
    }
  }
}

// Internal unsafe methods (no sorting, checking for existing figures, or adding to items)
internal extension Canvas {
  func intersectionItemBetween(_ straight: Straight, _ circular: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(straight.shape, circular.shape)
    return Intersection(shape, style: .init(), meta: .init(), canvas: self)
  }
  
  func intersectionItemBetween(_ circular0: Circular, _ circular1: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(circular0.shape, circular1.shape)
    return Intersection(shape, style: .init(), meta: .init(), canvas: self)
  }
}
