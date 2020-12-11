
public protocol FigureProtocol {
  associatedtype S: GeometricShape
  associatedtype Style: FigureStyle
  associatedtype Info: FigureInfo
  var shape: S { get }
  init(_ shape: S, style: Style, info: Info)
}
