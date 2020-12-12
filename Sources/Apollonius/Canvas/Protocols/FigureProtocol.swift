
public protocol FigureProtocol {
  associatedtype S: GeometricShape
  associatedtype Style: FigureStyle
  associatedtype Info
  var shape: S { get }
  var style: Style { get set }
  var info: Info { get set }
}
