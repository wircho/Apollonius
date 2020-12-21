import Foundation
import Numerics

public extension Canvas {
  final class Ray: LineOrRayOrSegment, FigureProtocolInternal {
    let storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var internalRepresentation: LineOrRayOrSegmentInternalRepresentation<T> { .init(shape: storage.shape) }
    
    public var style: LineStyle {
      get { storage.style }
      set { storage.style = newValue }
    }
    
    public var meta: FigureMeta {
      get { storage.meta }
      set { storage.meta = newValue }
    }
    
    public struct Value {
      public let origin: Coordinates
      public let directionAngle: T
    }
    
    public var value: Value? {
      guard let geometricValue = shape.value, let directionAngle = geometricValue.angle else { return nil }
      return .init(origin: geometricValue.origin.toCanvas(), directionAngle: directionAngle.value)
    }
    public var origin: Coordinates? { value?.origin }
    public var directionAngle: T? { value?.directionAngle }
  }
}

