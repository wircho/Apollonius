protocol Simplifiable {
  associatedtype Context
  associatedtype Simplified
  static func from(simplified: Simplified, context: Context) -> Self
  func simplified() -> Simplified
}
