
public extension Geometry.Circular {
  func contains(angle: SimpleAngle<T>) -> Bool? {
    guard let value = self.value else { return nil }
    return value.interval?.contains(angle) ?? true
  }
}

public extension Geometry.Circular {
  func cursorValue(near xy: XY<T>) -> SimpleAngle<T>? {
    guard let center = value?.center else { return nil }
    return (xy - center).angle
  }
}

