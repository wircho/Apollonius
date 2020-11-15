import Numerics

public struct AngleInterval<T: Real & Codable> {
  public let angle0: Angle<T>
  public let angle1: Angle<T>
  
  public init(_ angle0: Angle<T>, _ angle1: Angle<T>) {
      self.angle0 = angle0
      self.angle1 = angle1
  }
  
  public init(_ angle0: Angle<T>, _ angle1: Angle<T>, _ angle2: Angle<T>) {
    let possibleInterval = AngleInterval(angle0, angle2)
    guard possibleInterval.contains(angle1) else {
      self.init(angle2, angle0)
      return
    }
    self = possibleInterval
  }
}

public extension AngleInterval {
    func contains(_ angle: Angle<T>) -> Bool {
        let angle = angle.normalized
        let angle0 = self.angle0.normalized
        let angle1 = self.angle1.normalized
        switch angle0 <= angle1 {
        case true: return angle0 <= angle && angle <= angle1
        case false: return angle0 <= angle || angle <= angle1
        }
    }
}


