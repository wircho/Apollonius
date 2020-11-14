public extension Canvas {
  class PointHandle {
    public let point: Point
    weak var canvas: Canvas?
    let moveCursor: (XY<T>) -> Void
    let getCurrentState: () -> State
    var latestState: State
    var canvasUndoFreezeToken: UndoContext.FreezeToken? = nil
    var isMovingSmoothly: Bool { return canvasUndoFreezeToken != nil }
    
    struct State {
      var restore: () -> Void
      
      init<U>(cursor: Geometry.Cursor<U>, value: U) {
        restore = {
          cursor.value = value
        }
      }
    }
    
    func update() {
      self.canvas?.update(from: point.shape.key)
    }
    
    func move(to xy: XY<T>) {
      guard let canvas = canvas, !isMovingSmoothly else {
        moveCursor(xy)
        update()
        return
      }
      canvas.undoContext.perform {
        let oldState = getCurrentState()
        moveCursor(xy)
        update()
        let newState = getCurrentState()
        return .init(
          execute: { [unowned self] in
            oldState.restore()
            self.update()
          },
          revert: { [unowned self] in
            newState.restore()
            self.update()
          }
        )
      }
    }
    
    func beginSmoothMove() {
      guard let canvas = canvas, !isMovingSmoothly else { return }
      canvasUndoFreezeToken = canvas.undoContext.freeze()
    }
    
    func endSmoothMove() {
      guard let canvas = canvas, let canvasUndoFreezeToken = canvasUndoFreezeToken else { return }
      canvas.undoContext.unfreeze(token: canvasUndoFreezeToken)
    }
    
    public func move(to x: T, _ y: T) {
      move(to: .init(x: .init(value: x), y: .init(value: y)))
    }
    
    func recordState() -> State {
      let oldState = latestState
      latestState = getCurrentState()
      return oldState
    }
    
    init<U>(point: Point, cursor: Geometry.Cursor<U>, conversion: @escaping (XY<T>) -> U) {
      self.point = point
      moveCursor = { xy in
        cursor.value = conversion(xy)
      }
      getCurrentState = {
        let value = cursor.value
        return .init(cursor: cursor, value: value)
      }
      latestState = getCurrentState()
    }
  }
}
