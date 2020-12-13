import Numerics

extension Canvas {
  final class Intersection: FigureProtocolInternal {
    typealias Shape = Geometry.Intersection<T>
    typealias Style = EmptyStyle
    typealias Meta = Canvas.FigureMeta
    
    let shape: Shape
    var style: Style
    var meta: Meta
    
    init(_ shape: Shape, style: Style, meta: Meta) {
      self.shape = shape
      self.style = style
      self.meta = meta
    }
  }
}

// Internal unsafe static methods (no sorting, checking for existing figures, or adding to items)
internal extension Canvas {
  static func intersectionItemBetween(_ straight: Straight, _ circular: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(straight.shape, circular.shape)
    return Intersection(shape, style: .init(), meta: .init())
  }
  
  static func intersectionItemBetween(_ circular0: Circular, _ circular1: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(circular0.shape, circular1.shape)
    return Intersection(shape, style: .init(), meta: .init())
  }
}


