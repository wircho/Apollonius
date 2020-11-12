typealias Closure = () -> Void

struct Action {
  let execute: Closure
  let revert: Closure
}

extension Sequence where Element == Action {
  func grouped() -> Action {
    let array = Array(self)
    return Action(
      execute: { for action in array { action.execute() } },
      revert: { for action in array { action.revert() } }
    )
  }
}

final class UndoContext {
  var actions: [Action] = []
  var caret: Int = 0
  var groupingRange: Range<Int>? = nil
}

extension UndoContext {
  func perform(execute: @escaping Closure, revert: @escaping Closure, alreadyExecuted: Bool = false) {
    let action = Action(execute: execute, revert: revert)
    actions.removeSubrange(caret...)
    actions.append(action)
    caret += 1
    groupingRange = groupingRange.map{ $0.lowerBound ..< caret }
    if !alreadyExecuted { action.execute() }
  }
  
  func begingGrouping() {
    groupingRange = caret ..< caret
  }
  
  func endGrouping() {
    guard let groupingRange = self.groupingRange else { return }
    self.groupingRange = nil
    guard groupingRange.upperBound == actions.count, caret == actions.count else { return }
    actions.replaceSubrange(groupingRange, with: [actions[groupingRange].grouped()])
  }
  
  func undo() {
    guard caret > 0 else { return }
    let action = actions[caret - 1]
    caret -= 1
    groupingRange = nil
    action.revert()
  }
  
  func redo() {
    guard caret < actions.count else { return }
    let action = actions[caret]
    caret += 1
    groupingRange = nil
    action.execute()
  }
}
