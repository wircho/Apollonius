public protocol CanvasSpecifierProtocol {
  associatedtype FigureMeta: FigureMetaProtocol
  associatedtype PointStyle: FigureStyle
  associatedtype StraightStyle: FigureStyle
  associatedtype CircularStyle: FigureStyle
}

