
public protocol FigureProtocol {
  associatedtype Style: FigureStyle
  associatedtype Meta: Codable
  associatedtype Value = Void
  var style: Style { get set }
  var meta: Meta { get set }
  var value: Value? { get }
}

public extension FigureProtocol where Value == Void {
  var value: Void? { return () }
}
