protocol SimplifiableContext {
  init()
}

protocol Simplifiable {
  associatedtype Context: SimplifiableContext
  associatedtype Simplified
  static func from(simplified: Simplified, context: Context) -> Self
  func simplified() -> Simplified
}

extension Simplifiable {
  static func from(simplified: Simplified) -> Self {
    let context = Context()
    return from(simplified: simplified, context: context)
  }
}
