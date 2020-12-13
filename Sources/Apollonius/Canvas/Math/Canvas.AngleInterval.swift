public extension Canvas {
  struct AngleInterval {
    public let startAngle: T
    public let endAngle: T
    
    public init(startAngle: T, endAngle: T) {
      self.startAngle = startAngle
      self.endAngle = endAngle
    }
  }
}

extension AngleInterval {
  func toCanvas<Specifier: CanvasSpecifierProtocol>() -> Canvas<T, Specifier>.AngleInterval {
    return .init(startAngle: angle0.value, endAngle: angle1.value)
  }
}
