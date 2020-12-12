public protocol CanvasMetaProtocol {
  associatedtype Info: FigureInfo
  associatedtype PointStyle: FigureStyle
  associatedtype StraightStyle: FigureStyle
  associatedtype CircularStyle: FigureStyle
}
