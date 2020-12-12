import Foundation
import Numerics

public final class Canvas<T: Real & Codable, Specifier: CanvasSpecifierProtocol> {
  public typealias FigureMeta = Specifier.FigureMeta
  public typealias PointStyle = Specifier.PointStyle
  public typealias StraightStyle = Specifier.StraightStyle
  public typealias CircularStyle = Specifier.CircularStyle
  public typealias ScalarStyle = EmptyStyle
  typealias IntersectionStyle = EmptyStyle
  
  let undoManager = UndoManager()
  var items: OrderedDictionary<ObjectIdentifier, Item> = [:]
  var pointHandles: Dictionary<ObjectIdentifier, PointHandle> = [:]
  
  enum DesignatedParameter { case generic }
  
  init(_ parameter: DesignatedParameter) {
    undoManager.levelsOfUndo = 1
  }
}

public extension Canvas where T == Double, Specifier == DefaultCanvasSpecifier {
  convenience init() { self.init(.generic) }
}
