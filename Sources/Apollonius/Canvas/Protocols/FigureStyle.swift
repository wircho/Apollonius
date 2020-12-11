
public protocol FigureStyle: Codable {
  init()
}

public struct EmptyScalarStyle: FigureStyle {
  public init() {}
}

public struct EmptyIntersectionStyle: FigureStyle {
  public init() {}
}
