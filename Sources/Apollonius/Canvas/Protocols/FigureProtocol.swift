
public protocol FigureProtocol {
  associatedtype S: GeometricShape
  associatedtype Style: FigureStyle
  associatedtype Meta
  var shape: S { get }
  var style: Style { get set }
  var meta: Meta { get set }
}
