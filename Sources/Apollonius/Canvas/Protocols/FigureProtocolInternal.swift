
protocol FigureProtocolInternal: FigureProtocol, Simplifiable where Context == CanvasContext {
  associatedtype S: GeometricShape
  var shape: S { get }
  init(_ shape: S, style: Style, meta: Meta)
}
