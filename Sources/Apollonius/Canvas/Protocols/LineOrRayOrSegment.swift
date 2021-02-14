import Numerics

public struct LineOrRayOrSegmentInternalRepresentation<T: Real & Codable> {
  let shape: Geometry.Straight<T>
}

public protocol LineOrRayOrSegment: Curve {
  var internalRepresentation: LineOrRayOrSegmentInternalRepresentation<T> { get }
  var origin: Coordinates<T>? { get }
  var directionAngle: T? { get }
}

public extension LineOrRayOrSegment {
  var endpointKeys: Set<ObjectIdentifier> {
    Set(internalRepresentation.shape.endPoints.map { $0.key })
  }
}

