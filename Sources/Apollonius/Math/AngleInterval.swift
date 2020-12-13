import Numerics

struct AngleInterval<T: Real & Codable> {
  let angle0: SimpleAngle<T>
  let angle1: SimpleAngle<T>
  
  init(_ angle0: SimpleAngle<T>, _ angle1: SimpleAngle<T>) {
    self.angle0 = angle0.canonic()
    self.angle1 = angle1.canonic(greaterThan: self.angle0.value)
  }
  
  init(_ angle0: SimpleAngle<T>, _ angle1: SimpleAngle<T>, _ angle2: SimpleAngle<T>) {
    let possibleInterval = AngleInterval(angle0, angle2)
    guard possibleInterval.contains(angle1) else {
      self.init(angle2, angle0)
      return
    }
    self = possibleInterval
  }
}

extension AngleInterval {
  func contains(_ exactAngleValue: T) -> Bool {
    return angle0.value <= exactAngleValue && exactAngleValue <= angle1.value
  }
  
  func contains(_ angle: SimpleAngle<T>) -> Bool {
    let angle = angle.canonic()
    return contains(angle.value) || contains(angle.value + 2 * .pi)
  }
}


