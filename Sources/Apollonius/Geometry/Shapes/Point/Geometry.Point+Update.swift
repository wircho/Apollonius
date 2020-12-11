import Numerics

extension Geometry.Point: GeometricShapeInternal {
  public func newValue() -> XY<T>? {
    switch parameters {
    case let .fixed(position):
      return position
    case let .free(cursor):
      return cursor.value
    case let ._onStraightAbsolute(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value)
    case let ._onStraightNormalized(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value * straightValue.length)
    case let ._onCircular(circular, cursor):
      guard let circularValue = circular.inner.object.value else { return nil }
      return circularValue.center + cursor.value.dxy(at: circularValue.radius)
    case let ._intersection(intersection, index):
      return intersection.inner.object[index]
    case let ._oppositeIntersection(intersection, oppositePoint):
      guard let value = intersection.inner.object.value else { return nil }
      return value.opposite(to: oppositePoint.inner.object.value)
    case let ._twoStraightsIntersection(straight0, straight1):
      guard let straightValue0 = straight0.inner.object.value, let straightValue1 = straight1.inner.object.value else { return nil }
      let origin0 = straightValue0.origin
      let origin1 = straightValue1.origin
      let vector0 = straightValue0.vector
      let vector1 = straightValue1.vector
      let originDifference = origin1 - origin0
      let numerator0 = originDifference.dx * vector1.dy - vector1.dx * originDifference.dy
      let numerator1 = vector0.dx * originDifference.dy - originDifference.dx * vector0.dy
      let denominator = vector0.dx * vector1.dy - vector1.dx * vector0.dy
      guard let value0 = numerator0 / denominator, let value1 = numerator1 / denominator else { return nil }
      guard straight0.inner.object.contains(normalizedValue: value0) == true
        && straight1.inner.object.contains(normalizedValue: value1) == true else {
          return nil
      }
      return origin0 + value0 * vector0
    case let ._circumcenter(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      return XY<T>.circumcenter(xy0, xy1, xy2)
    }
  }
}
