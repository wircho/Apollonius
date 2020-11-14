public typealias Closure = () -> Void
extension Sequence where Element == UndoContext.Action {
  func grouped() -> UndoContext.Action {
    let array = Array(self)
    return .init(
      execute: { for action in array { action.execute() } },
      revert: { for action in array { action.revert() } }
    )
  }
}

final public class UndoContext {
  public struct Action {
    let execute: Closure
    let revert: Closure
  }
  
  final public class FreezeToken {}
  
  var actions: [Action] = []
  var caret: Int = 0
  var groupingRanges: [Range<Int>] = []
  var freezeToken: FreezeToken? = nil
  var frozen: Bool { return freezeToken != nil }
  var memory = 0
}

public extension UndoContext {
  var canUndo: Bool { return !frozen && caret > 0 }
  var carRedo: Bool { return !frozen && caret < actions.count }
  
  func freeze() -> FreezeToken? {
    guard !frozen else { return nil }
    let freezeToken = FreezeToken()
    self.freezeToken = freezeToken
    return freezeToken
  }
  
  func unfreeze(token: FreezeToken) {
    guard token === freezeToken else { return }
    freezeToken = nil
  }
  
  func clear() {
    guard !frozen else { return }
    actions = []
    caret = 0
    groupingRanges = []
  }
  
  func unsafeAppend(action: Action) {
    guard memory > 0 else { return }
    actions.removeSubrange(caret...)
    actions.append(action)
    let removeFirst = actions.count > memory
    if removeFirst { actions.removeFirst() }
    caret = actions.count
    groupingRanges = groupingRanges.map{ (removeFirst ? $0.lowerBound - 1 : $0.lowerBound) ..< caret }
  }
  
  func perform(execute: @escaping Closure, revert: @escaping Closure) {
    guard !frozen else { return }
    let action = Action(execute: execute, revert: revert)
    unsafeAppend(action: action)
    action.execute()
  }
  
  func perform(_ executeNow: () -> Action) {
    guard !frozen else { return }
    let action = executeNow()
    unsafeAppend(action: action)
  }
  
  func begingGrouping() {
    guard !frozen else { return }
    groupingRanges.append(caret ..< caret)
  }
  
  func endGrouping() {
    guard !frozen else { return }
    guard let groupingRange = groupingRanges.last else { return }
    groupingRanges.removeLast()
    guard groupingRange.upperBound == actions.count, caret == actions.count else { return }
    actions.replaceSubrange(groupingRange, with: [actions[groupingRange].grouped()])
  }
  
  func undo() {
    guard !frozen else { return }
    guard caret > 0 else { return }
    let action = actions[caret - 1]
    caret -= 1
    groupingRanges = []
    action.revert()
  }
  
  func redo() {
    guard !frozen else { return }
    guard caret < actions.count else { return }
    let action = actions[caret]
    caret += 1
    groupingRanges = []
    action.execute()
  }
}
