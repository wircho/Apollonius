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
    
    var isBlockedByUndoManager: Bool {
      guard let isUndoRegistrationEnabled = canvas?.undoManager?.isUndoRegistrationEnabled else { return false }
      return !isUndoRegistrationEnabled
    }
    
    var isAllowedToMove: Bool { isMovingSmoothly || !isBlockedByUndoManager }
    
    var isAllowedToRestore: Bool { !isMovingSmoothly && !isBlockedByUndoManager }
    
    var isAllowedToRecordState: Bool { !isMovingSmoothly }
    
    var isAllowedToBeginSmoothMove: Bool { !isMovingSmoothly && !isBlockedByUndoManager }
    
    var isAllowedToEndSmoothMove: Bool { isMovingSmoothly }
    
    func move(to xy: XY<T>) {
      guard isAllowedToMove else { return }
      canvas?.willChangeHandler?()
      moveCursorAndUpdate(to: xy)
      recordStateAndRegisterUndoIfNeeded()
    }
    
    func restoreAndUpdate(_ state: State) {
      guard isAllowedToRestore else { return }
      canvas?.willChangeHandler?()
      state.restore()
      update()
      recordStateAndRegisterUndoIfNeeded()
    }
    
    func recordStateAndRegisterUndoIfNeeded() {
      guard isAllowedToRecordState, let undoManager = canvas?.undoManager else { return }
      
      let oldState = latestState
      let newState = getCurrentState()
      latestState = newState
      
      undoManager.beginUndoGrouping()
      undoManager.registerUndo(withTarget: self) { handle in
        handle.restoreAndUpdate(oldState)
      }
      undoManager.endUndoGrouping()
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

public extension Canvas.PointHandle {
  func beginSmoothMove() {
    guard isAllowedToBeginSmoothMove else { return }
    isMovingSmoothly = true
    canvas?.undoManager?.disableUndoRegistration()
    dependantKeys = canvas?.gatherKeys(from: self.point.shape.key)
  }
  
  func endSmoothMove() {
    guard isAllowedToEndSmoothMove else { return }
    isMovingSmoothly = false
    canvas?.undoManager?.enableUndoRegistration()
    dependantKeys = nil
    recordStateAndRegisterUndoIfNeeded()
  }
  
  func move(to x: T, _ y: T) {
    move(to: .init(x: .init(value: x), y: .init(value: y)))
  }
}
