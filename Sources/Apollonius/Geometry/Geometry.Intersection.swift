import Numerics

public extension Geometry {
  enum IntersectionParameters<T: Real> {
    case _straightCircular(UnownedStraight<T>, UnownedCircular<T>)
    case _twoCirculars(UnownedCircular<T>, UnownedCircular<T>)
    
    public static func between(_ straight: Straight<T>, _ circular: Circular<T>) -> IntersectionParameters<T> {
      return ._straightCircular(.init(straight), .init(circular))
    }
    
    public static func between(_ circular0: Circular<T>, _ circular1: Circular<T>) -> IntersectionParameters<T> {
      return ._twoCirculars(.init(circular0), .init(circular1))
    }
  }
  
  final class Intersection<T: Real> {
    public struct Value {
      public let first: XY<T>?
      public let second: XY<T>?
    }
    
    public let index = Counter.shapeIndex.newIndex()
    public var value: Value? = nil
    public let parameters: IntersectionParameters<T>
    public var children: [UnownedShape<T>] = []
    
    public init(_ parameters: IntersectionParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let ._straightCircular(straight, circular):
        // Parenting
        straight.inner.object.children.append(UnownedShape(self))
        circular.inner.object.children.append(UnownedShape(self))
      case let ._twoCirculars(circular0, circular1):
        // Parenting
        circular0.inner.object.children.append(UnownedShape(self))
        circular1.inner.object.children.append(UnownedShape(self))
      }
    }
  }
}

extension Geometry.Intersection: Shape {
  private func intersections(between straight: Geometry.Straight<T>, and circular: Geometry.Circular<T>) -> Value? {
    guard let straightValue = straight.value, let circularValue = circular.value else { return nil }
    let vector = straightValue.vector
    let origin = straightValue.origin
    let center = circularValue.center
    let radius = circularValue.radius
    let centerToOrigin = origin - center
    let a = vector.normSquared()
    let b = 2 * (vector • centerToOrigin)
    let c = centerToOrigin.normSquared() - radius.squared()
    let discriminant = b.squared() - 4 * (a * c)
    guard let discriminantSquareRoot = discriminant.squareRoot() else { return nil }
    let numerators = (-b + discriminantSquareRoot, -b - discriminantSquareRoot)
    let denominator = 2 * a
    let t = [numerators.0 / denominator, numerators.0 / denominator].map { (t: T?) -> T? in
      guard let t = t, straight.contains(normalizedValue: t) == true else { return nil }
      return t
    }
    let xy = t.map { (t: T?) -> XY<T>? in
      guard let t = t else { return nil }
      let xy = origin + t * vector
      guard let angle = (xy - center).angle else { return xy }
      guard circular.contains(angle: angle) == true else { return nil }
      return xy
    }
    return .init(first: xy[0], second: xy[1])
  }
  
  private func intersections(between circular0: Geometry.Circular<T>, and circular1: Geometry.Circular<T>) -> Value? {
    guard let circularValue0 = circular0.value, let circularValue1 = circular1.value else { return nil }
    let center0 = circularValue0.center
    let radius0 = circularValue0.radius
    let center1 = circularValue1.center
    let radius1 = circularValue1.radius
    let vector = center1 - center0
    let d2 = vector.normSquared()
    let radiusSquared0 = radius0.squared()
    let radiusSquared1 = radius1.squared()
    let squaresSum = radiusSquared0 + radiusSquared1
    let squaresDifference = radiusSquared0 - radiusSquared1
    guard let a = squaresSum / d2, let b = squaresDifference / d2 else { return nil }
    let discriminant = (2 * a - b * b - 1).squareRoot() / 2
    guard discriminant.isFinite else { return nil }
    let vector90 = vector.rotated90Degrees
    let midpoint = center0 + (vector / 2)!
    let firstTerm = midpoint + (b / 2) * vector
    let secondTerm = (discriminant / 2) * vector90
    let xy = [firstTerm + secondTerm, firstTerm - secondTerm].map { (xy: XY<T>) -> XY<T>? in
      guard let angle = (xy - center0).angle else { return xy }
      guard circular0.contains(angle: angle) == true else { return nil }
      return xy
    }.map { (xy: XY<T>?) -> XY<T>? in
      guard let xy = xy else { return nil }
      guard let angle = (xy - center1).angle else { return xy }
      guard circular1.contains(angle: angle) == true else { return nil }
      return xy
    }
    return .init(first: xy[0], second: xy[1])
  }
  
  public func newValue() -> Value? {
    switch parameters {
    case let ._straightCircular(straight, circular): return intersections(between: straight.inner.object, and: circular.inner.object)
    case let ._twoCirculars(circular0, circular1): return intersections(between: circular0.inner.object, and: circular1.inner.object)
    }
  }
}

public extension Geometry {
  enum IntersectionIndex: String, Codable {
    case first, second
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

public extension Geometry.Intersection {
  static func between(_ straight: Geometry.Straight<T>, _ circular: Geometry.Circular<T>) -> Geometry.Intersection<T> {
    return .init(.between(straight, circular))
  }
  
  static func between(_ circular0: Geometry.Circular<T>, _ circular1: Geometry.Circular<T>) -> Geometry.Intersection<T> {
    return .init(.between(circular0, circular1))
  }
}

public struct UnownedIntersection<T: Real>: UnownedShapeConvertibleInternal {
  let inner: Unowned<Geometry.Intersection<T>>
  public let asUnownedShape: UnownedShape<T>
  
  init(_ intersection: Geometry.Intersection<T>) {
    inner = .init(intersection)
    asUnownedShape = .init(intersection)
  }
}
