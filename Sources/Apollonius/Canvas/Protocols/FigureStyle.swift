
public protocol FigureStyle: Codable {
  init()
}

public struct EmptyStyle: FigureStyle {
  public init() {}
}
