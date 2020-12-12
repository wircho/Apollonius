import Numerics

extension Canvas {
  typealias Intersection = Figure<Geometry.Intersection<T>, IntersectionStyle>
}

// Internal unsafe static methods (no sorting, checking for existing figures, or adding to items)
internal extension Canvas {
  static func intersectionItemBetween(_ straight: Straight, _ circular: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(straight.shape, circular.shape)
    return Intersection(shape)
  }
  
  static func intersectionItemBetween(_ circular0: Circular, _ circular1: Circular) -> Intersection {
    let shape = Geometry.Intersection.between(circular0.shape, circular1.shape)
    return Intersection(shape)
  }
}


