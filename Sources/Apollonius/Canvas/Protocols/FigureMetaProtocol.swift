
public protocol FigureMetaProtocol: Codable {
  init()
}

public struct EmptyMeta: FigureMetaProtocol {
  public init() {}
}
