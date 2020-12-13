import Numerics

struct SimpleAngle<T: Real & Codable>: SimpleValue {
    let value: T
    init(value: T) { self.value = value }
}

extension SimpleAngle {
  func canonic(greaterThan lowerBound: T = 0) -> SimpleAngle {
    let twoPi = 2 * T.pi
    let upperBound = lowerBound + twoPi
    var value = self.value
    while value < lowerBound { value += twoPi }
    while value >= upperBound { value -= twoPi }
    return .init(value: value)
  }
    
  var cos: T { return .cos(value) }
  var sin: T { return .sin(value) }
  
  func dxy(at length: Length<T>) -> DXY<T> {
    return .init(
      dx: (cos * length).asDX,
      dy: (sin * length).asDY
    )
  }
}

extension Length {
    func dxy(at angle: SimpleAngle<T>) -> DXY<T> {
        return angle.dxy(at: self)
    }
}
