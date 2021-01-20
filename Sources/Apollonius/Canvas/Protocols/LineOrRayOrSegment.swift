import Numerics

public struct LineOrRayOrSegmentInternalRepresentation<T: Real & Codable> {
  let shape: Geometry.Straight<T>
}

public protocol LineOrRayOrSegment: FigureProtocol {
  var internalRepresentation: LineOrRayOrSegmentInternalRepresentation<T> { get }
  var origin: Coordinates<T>? { get }
  var directionAngle: T? { get }
}

