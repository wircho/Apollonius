public extension Canvas {
  final class Figure<S: GeometricShape, Style: FigureStyle>: FigureProtocol where S.T == T {
    public typealias Meta = Canvas.FigureMeta
    
    public let shape: S
    public var style: Style
    public var meta: Meta
    
    init(_ shape: S, style: Style, meta: Meta) {
      self.shape = shape
      self.style = style
      self.meta = meta
    }
  }
}

extension Canvas.Figure: FigureProtocolInternal where S: GeometricShapeInternal {}
