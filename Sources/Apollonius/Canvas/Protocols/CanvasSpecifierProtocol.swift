public protocol CanvasSpecifierProtocol {
  associatedtype FigureMeta: FigureMetaProtocol
  associatedtype PointStyle: FigureStyle
  associatedtype LineStyle: FigureStyle
  associatedtype CurveStyle: FigureStyle
}

