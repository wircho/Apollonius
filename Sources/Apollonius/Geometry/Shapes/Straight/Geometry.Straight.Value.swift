
public extension Geometry.Straight {
  struct Value {
    public let origin: XY<T>
    public let tip: XY<T>
  }
}

public extension Geometry.Straight.Value {
  var vector: DXY<T> {
    return tip - origin
  }
  
  var angle: SimpleAngle<T>? {
    return vector.angle
  }
  
  var length: Length<T> {
    return vector.norm()
  }
}

public extension Geometry.Straight {
  var vector: DXY<T>? {
    return value?.vector
  }
  
  func contains(normalizedValue: T) -> Bool? {
    guard value != nil else { return nil }
    switch parameters.kind {
    case .line: return true
    case .ray: return normalizedValue >= 0
    case .segment: return normalizedValue >= 0 && normalizedValue <= 1
    }
  }
  
  func contains(absoluteValue: Length<T>) -> Bool? {
    guard let length = value?.length else { return nil }
    switch parameters.kind {
    case .line: return true
    case .ray: return absoluteValue >= 0
    case .segment: return absoluteValue >= 0 && absoluteValue <= length
    }
  }
}

public extension Geometry.Straight.Value {
  fileprivate func unrestrictedAbsoluteCursorValueAndNorm(near xy: XY<T>) -> (Length<T>, Length<T>)? {
    let vector = self.vector
    let xyVector = xy - origin
    let norm = vector.norm()
    return ((vector • xyVector) / norm).map{ ($0, norm) }
  }
}

public extension Geometry.Straight {
  func normalizedCursorValue(near xy: XY<T>) -> T? {
    guard let (unrestricted, norm) = value?.unrestrictedAbsoluteCursorValueAndNorm(near: xy) else { return nil }
    switch parameters.kind {
    case .line: return unrestricted / norm
    case .ray: return (unrestricted < 0) ? 0 : unrestricted / norm
    case .segment: return (unrestricted < 0) ? 0 : (unrestricted > norm) ? 1 : unrestricted / norm
    }
  }
  
  func absoluteCursorValue(near xy: XY<T>) -> Length<T>? {
    guard let (unrestricted, norm) = value?.unrestrictedAbsoluteCursorValueAndNorm(near: xy) else { return nil }
    switch parameters.kind {
    case .line: return unrestricted
    case .ray: return (unrestricted < 0) ? .init(value: 0) : unrestricted
    case .segment: return (unrestricted < 0) ? .init(value: 0) : (unrestricted > norm) ? norm : unrestricted
    }
  }
}
