import Foundation
import Numerics

public extension Canvas {
  final class Ray: LineOrRayOrSegmentInternal {
    let storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>) {
      self.storage = storage
    }
    
    static var kind: Geometry.StraightKind { .ray }
    
    public var internalRepresentation: LineOrRayOrSegmentInternalRepresentation<T> { .init(shape: storage.shape) }
    
    public var key: ObjectIdentifier { storage.shape.key }
    
    public var style: LineStyle {
      get { storage.style }
      set { storage.style = newValue }
    }
    
    public var meta: FigureMeta {
      get { storage.meta }
      set { storage.meta = newValue }
    }
    
    public struct Value {
      public let origin: Coordinates<T>
      public let directionAngle: T
    }
    
    public var value: Value? {
      guard let geometricValue = shape.value, let directionAngle = geometricValue.angle else { return nil }
      return .init(origin: geometricValue.origin.toCanvas(), directionAngle: directionAngle.value)
    }
    public var origin: Coordinates<T>? { value?.origin }
    public var directionAngle: T? { value?.directionAngle }
  }
}

