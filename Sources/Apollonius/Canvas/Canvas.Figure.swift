public extension Canvas {
  final class Figure<S: GeometricShape, Style: FigureStyle>: FigureProtocol where S.T == T {
    public typealias Info = Canvas.Info
    
    public let shape: S
    public var style: Style
    public var info: Info
    
    init(_ shape: S, style: Style = .init(), info: Info = .init()) {
      self.shape = shape
      self.style = style
      self.info = info
    }
  }
}

extension Canvas.Figure: FigureProtocolInternal where S: GeometricShapeInternal {}
