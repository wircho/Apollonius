import Numerics

public struct Coordinates<T: Real & Codable> {
  public let x: T
  public let y: T
  
  public init(x: T, y: T) {
    self.x = x
    self.y = y
  }
}

extension XY {
  func toCanvas() -> Coordinates<T> {
    return .init(x: x.value, y: y.value)
  }
}
