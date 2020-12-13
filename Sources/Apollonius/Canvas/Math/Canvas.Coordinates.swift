public extension Canvas {
  struct Coordinates {
    public let x: T
    public let y: T
    
    public init(x: T, y: T) {
      self.x = x
      self.y = y
    }
  }
}

extension XY {
  func toCanvas<Specifier: CanvasSpecifierProtocol>() -> Canvas<T, Specifier>.Coordinates {
    return .init(x: x.value, y: y.value)
  }
}
