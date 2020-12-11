import Numerics

extension Geometry.Intersection: GeometricShapeInternal {
  public func newValue() -> Value? {
    switch parameters {
    case let ._straightCircular(straight, circular): return intersections(between: straight.inner.object, and: circular.inner.object)
    case let ._twoCirculars(circular0, circular1): return intersections(between: circular0.inner.object, and: circular1.inner.object)
    }
  }
}

private extension Geometry.Intersection {
  func intersections(between straight: Geometry.Straight<T>, and circular: Geometry.Circular<T>) -> Value? {
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
  
  func intersections(between circular0: Geometry.Circular<T>, and circular1: Geometry.Circular<T>) -> Value? {
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
}
