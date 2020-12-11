
extension Geometry.Intersection {
  public struct Value {
    public let first: XY<T>?
    public let second: XY<T>?
  }
}

public extension Geometry.Intersection.Value {
  subscript(_ index: Geometry.IntersectionIndex) -> XY<T>? {
    switch index {
    case .first: return first
    case .second: return second
    }
  }
  
  var midpoint: XY<T>? {
    guard let first = first, let second = second else { return nil }
    return first + ((second - first) / 2)!
  }
  
  func opposite(to xy: XY<T>?) -> XY<T>? {
    guard let xy = xy, let midpoint = midpoint else { return nil }
    return midpoint + (midpoint - xy)
  }
}

public extension Geometry.Intersection {
  subscript(_ index: Geometry.IntersectionIndex) -> XY<T>? {
    return value?[index]
  }
}
