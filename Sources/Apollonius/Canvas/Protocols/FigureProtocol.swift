import Foundation

final class FigureProtocolStorage<S: GeometricShape, Style: FigureStyle, Meta: Codable> {
  let shape: S
  weak var undoManager: UndoManager?
  let willChangeMetadataHandler: () -> Void
  private var _style: Style
  private var _meta: Meta
  
  var style: Style {
    get { return _style }
    set {
      willChangeMetadataHandler()
      let oldValue = _style
      _style = newValue
      undoManager?.registerUndo(withTarget: self) { $0.style = oldValue }
    }
  }
  
  var meta: Meta {
    get { return _meta }
    set {
      willChangeMetadataHandler()
      let oldValue = _meta
      _meta = newValue
      undoManager?.registerUndo(withTarget: self) { $0.meta = oldValue }
    }
  }
  
  init<CS: CanvasSpecifierProtocol>(_ shape: S, style: Style, meta: Meta, canvas: Canvas<S.T, CS>?) {
    self.shape = shape
    self.undoManager = canvas?.undoManager
    self.willChangeMetadataHandler = { [weak canvas] in canvas?.willChangeHandler?() }
    self._style = style
    self._meta = meta
  }
}

protocol FigureProtocol: AnyObject, Simplifiable where Context == CanvasContext<S.T, Specifier> {
  associatedtype Specifier: CanvasSpecifierProtocol
  associatedtype S: GeometricShape
  associatedtype Style: FigureStyle
  associatedtype Meta: Codable
  var style: Style { get }
  var meta: Meta { get }
  var storage: FigureProtocolStorage<S, Style, Meta> { get }
  init(storage: FigureProtocolStorage<S, Style, Meta>)
}

extension FigureProtocol {
  var shape: S { storage.shape }
  
  init(_ shape: S, style: Style, meta: Meta, canvas: Canvas<S.T, Specifier>?) {
    self.init(storage: .init(shape, style: style, meta: meta, canvas: canvas))
  }
}

protocol UnstyledFigureProtocol: FigureProtocol {}

extension UnstyledFigureProtocol {
  var style: Style { storage.style }
  var meta: Meta { storage.meta }
}
