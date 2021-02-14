public protocol Curve: FigureProtocol {
  var endpointKeys: Set<ObjectIdentifier> { get }
}

