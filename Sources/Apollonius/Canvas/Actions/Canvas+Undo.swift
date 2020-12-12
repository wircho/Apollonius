public extension Canvas {
  func undo() {
    undoManager.undo()
  }
  
  func redo() {
    undoManager.redo()
  }
  
  var canUndo: Bool {
    undoManager.canUndo
  }
  
  var canRedo: Bool {
    undoManager.canRedo
  }
  
  var groupsUndosByEvent: Bool {
    get { undoManager.groupsByEvent }
    set { undoManager.groupsByEvent = newValue }
  }
  
  var levelsOfUndo: Int {
    get { undoManager.levelsOfUndo }
    set { undoManager.levelsOfUndo = newValue }
  }
}
