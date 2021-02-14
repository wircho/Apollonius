import Numerics

public struct CircleOrArcInternalRepresentation<T: Real & Codable> {
  let shape: Geometry.Circular<T>
}

public protocol CircleOrArc: Curve {
  var internalRepresentation: CircleOrArcInternalRepresentation<T> { get }
  var center: Coordinates<T>? { get }
  var radius: T? { get }
}

public extension CircleOrArc {
  var endpointKeys: Set<ObjectIdentifier> {
    Set(internalRepresentation.shape.endPoints.map { $0.key })
  }
}

