public protocol RepresentableFromProxy {
  associatedtype Proxy
  init(proxy: Proxy) throws
}

public protocol RepresentableToProxy {
  associatedtype Proxy
  func toProxy() throws -> Proxy
}

public typealias RepresentableByProxy = RepresentableFromProxy & RepresentableToProxy

public protocol DecodableByProxy: RepresentableFromProxy, Decodable where Proxy: Decodable {}

public extension DecodableByProxy {
  init(from decoder: Decoder) throws {
    let proxy = try Proxy.init(from: decoder)
    self = try .init(proxy: proxy)
  }
}

public protocol EncodableByProxy: RepresentableToProxy, Encodable where Proxy: Encodable {}

public extension EncodableByProxy {
  func encode(to encoder: Encoder) throws {
    try toProxy().encode(to: encoder)
  }
}

public typealias CodableByProxy = DecodableByProxy & EncodableByProxy
