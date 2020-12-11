public extension Canvas {
  class PointHandle {
    public let point: Point
    weak var canvas: Canvas?
    let moveCursor: (XY<T>) -> Void
    let getCurrentState: () -> State
    var latestState: State
    var dependantKeys: Set<ObjectIdentifier>? = nil
    var isMovingSmoothly: Bool = false
    
    struct State {
      var restore: () -> Void
      
      init<U>(cursor: Geometry.Cursor<U>, value: U) {
        restore = {
          cursor.value = value
        }
      }
    }
    
    func update() {
      guard let canvas = canvas else { return }
      canvas.update(keys: dependantKeys ?? canvas.gatherKeys(from: self.point.shape.key))
    }
    
    func moveCursorAndUpdate(to xy: XY<T>) {
      moveCursor(xy)
      update()
    }
    
    func move(to xy: XY<T>) {
      guard isMovingSmoothly || canvas?.undoManager.isUndoRegistrationEnabled ?? true else { return }
      moveCursorAndUpdate(to: xy)
      recordStateAndRegisterUndoIfNeeded()
    }
    
    func restoreAndUpdate(_ state: State) {
      guard !isMovingSmoothly && canvas?.undoManager.isUndoRegistrationEnabled ?? true else { return }
      state.restore()
      update()
      recordStateAndRegisterUndoIfNeeded()
    }
    
    public func beginSmoothMove() {
      guard !isMovingSmoothly && canvas?.undoManager.isUndoRegistrationEnabled ?? true else { return }
      isMovingSmoothly = true
      canvas?.undoManager.disableUndoRegistration()
      dependantKeys = canvas?.gatherKeys(from: self.point.shape.key)
    }
    
    public func endSmoothMove() {
      guard isMovingSmoothly else { return }
      isMovingSmoothly = false
      canvas?.undoManager.enableUndoRegistration()
      dependantKeys = nil
      recordStateAndRegisterUndoIfNeeded()
    }
    
    public func move(to x: T, _ y: T) {
      move(to: .init(x: .init(value: x), y: .init(value: y)))
    }
    
    func recordStateAndRegisterUndoIfNeeded() {
      guard !isMovingSmoothly else { return }
      
      let oldState = latestState
      let newState = getCurrentState()
      latestState = newState
      
      if #available(OSX 10.11, iOS 9.0, *) {
        canvas?.undoManager.beginUndoGrouping()
        canvas?.undoManager.registerUndo(withTarget: self) { handle in
          handle.restoreAndUpdate(oldState)
        }
        canvas?.undoManager.endUndoGrouping()
      }
    }
    
    init<U>(point: Point, cursor: Geometry.Cursor<U>, canvas: Canvas, conversion: @escaping (XY<T>) -> U) {
      self.point = point
      self.canvas = canvas
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
