import Numerics

public struct AngleInterval<T: Real & Codable> {
  public let angle0: SimpleAngle<T>
  public let angle1: SimpleAngle<T>
  
  init(_ angle0: SimpleAngle<T>, _ angle1: SimpleAngle<T>) {
      self.angle0 = angle0
      self.angle1 = angle1
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
    func contains(_ angle: SimpleAngle<T>) -> Bool {
        let angle = angle.normalized
        let angle0 = self.angle0.normalized
        let angle1 = self.angle1.normalized
        switch angle0 <= angle1 {
        case true: return angle0 <= angle && angle <= angle1
        case false: return angle0 <= angle || angle <= angle1
        }
    }
}


