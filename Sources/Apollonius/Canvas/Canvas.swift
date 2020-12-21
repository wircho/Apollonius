import Foundation
import Numerics

public final class Canvas<T: Real & Codable, Specifier: CanvasSpecifierProtocol> {
  public typealias FigureMeta = Specifier.FigureMeta
  public typealias PointStyle = Specifier.PointStyle
  public typealias LineStyle = Specifier.LineStyle
  public typealias CurveStyle = Specifier.CurveStyle
  public typealias ScalarStyle = EmptyStyle
  typealias IntersectionStyle = EmptyStyle
  
  let undoManager: UndoManager?
  var items: OrderedDictionary<ObjectIdentifier, Item> = [:]
  var pointHandles: Dictionary<ObjectIdentifier, PointHandle> = [:]
  
  let willChangeHandler: (() -> Void)?
  
  enum DesignatedParameter { case generic }
  
  init(_ parameter: DesignatedParameter, allowsUndo: Bool = false, willChangeHandler: (() -> Void)? = nil) {
    undoManager = allowsUndo ? .init() : nil
    self.willChangeHandler = willChangeHandler
  }
}

public extension Canvas {
  convenience init(numericalType: T.Type, specifierType: Specifier.Type, allowsUndo: Bool = false, willChangeHandler: (() -> Void)? = nil) {
    self.init(.generic, allowsUndo: allowsUndo, willChangeHandler: willChangeHandler)
  }
}

public extension Canvas where Specifier == DefaultCanvasSpecifier {
  convenience init(numericalType: T.Type, allowsUndo: Bool = false, willChangeHandler: (() -> Void)? = nil) {
    self.init(.generic, allowsUndo: allowsUndo, willChangeHandler: willChangeHandler)
  }
}

public extension Canvas where T == Double, Specifier == DefaultCanvasSpecifier {
  convenience init(allowsUndo: Bool = false, willChangeHandler: (() -> Void)? = nil) {
    self.init(.generic, allowsUndo: allowsUndo, willChangeHandler: willChangeHandler)
  }
}
