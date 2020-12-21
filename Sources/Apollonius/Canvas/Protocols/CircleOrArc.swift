import Numerics

public struct CircleOrArcInternalRepresentation<T: Real & Codable> {
  let shape: Geometry.Circular<T>
}

public protocol CircleOrArc: FigureProtocol {
  var internalRepresentation: CircleOrArcInternalRepresentation<T> { get }
}
