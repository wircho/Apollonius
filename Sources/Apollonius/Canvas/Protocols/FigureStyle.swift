
public protocol FigureStyle: Codable {
  init()
}

public struct EmptyScalarStyle: FigureStyle {
  public init() {}
}

struct EmptyIntersectionStyle: FigureStyle {
  init() {}
}
