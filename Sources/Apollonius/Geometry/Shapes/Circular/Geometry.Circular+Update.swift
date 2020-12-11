import Numerics

extension Geometry.Circular: GeometricCurveInternal {
  public func newValue() -> Geometry.Circular<T>.Value? {
    switch parameters {
    case let ._between(center, tip):
      guard let center = center.inner.object.value, let tip = tip.inner.object.value else { return nil }
      return .init(center: center, radius: (tip - center).norm(), interval: nil)
    case let ._with(center, radius):
      guard let center = center.inner.object.value, let radius = radius.inner.object.value else { return nil }
      return .init(center: center, radius: radius, interval: nil)
    case let ._circumcircle(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      guard let center = XY<T>.circumcenter(xy0, xy1, xy2) else { return nil }
      let radius = (xy0 - center).norm()
      return .init(center: center, radius: radius, interval: nil)
    case let ._arc(point0, point1, point2):
      guard let xy0 = point0.inner.object.value,  let xy1 = point1.inner.object.value,  let xy2 = point2.inner.object.value else { return nil }
      guard let center = XY<T>.circumcenter(xy0, xy1, xy2) else { return nil }
      guard let angle0 = (xy0 - center).angle, let angle1 = (xy1 - center).angle, let angle2 = (xy2 - center).angle else { return nil }
      let radius = (xy0 - center).norm()
      let interval = AngleInterval(angle0, angle1, angle2)
      return .init(center: center, radius: radius, interval: interval)
    }
  }
}
