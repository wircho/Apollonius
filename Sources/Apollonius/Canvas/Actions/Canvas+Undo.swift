public extension Canvas {
  var allowsUndo: Bool { undoManager != nil }
  
  func undo() {
    undoManager?.undo()
  }
  
  func redo() {
    undoManager?.redo()
  }
  
  var canUndo: Bool {
    undoManager?.canUndo ?? false
  }
  
  var canRedo: Bool {
    undoManager?.canRedo ?? false
  }
  
  var groupsUndosByEvent: Bool {
    get { undoManager?.groupsByEvent ?? false }
    set { undoManager?.groupsByEvent = newValue }
  }
  
  var levelsOfUndo: Int {
    get { undoManager?.levelsOfUndo ?? 0 }
    set { undoManager?.levelsOfUndo = newValue }
  }
}
