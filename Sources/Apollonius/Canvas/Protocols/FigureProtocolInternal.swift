
protocol FigureProtocolInternal: FigureProtocol where S: GeometricShapeInternal {
  init(_ shape: S, style: Style, info: Info)
}
