import Foundation
import Numerics

public extension Canvas {
  final class Circle: CircleOrArcInternal {
    
    let storage: FigureProtocolStorage<Geometry.Circular<T>, CurveStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Circular<T>, CurveStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var internalRepresentation: CircleOrArcInternalRepresentation<T> { .init(shape: storage.shape) }
    
    public var key: ObjectIdentifier { storage.shape.key }
    
    public var style: CurveStyle {
      get { storage.style }
      set { storage.style = newValue }
    }
    
    public var meta: FigureMeta {
      get { storage.meta }
      set { storage.meta = newValue }
    }
    
    public struct Value {
      public let center: Coordinates<T>
      public let radius: T
    }
    
    public var value: Value? {
      guard let geometricValue = shape.value else { return nil }
      return .init(center: geometricValue.center.toCanvas(), radius: geometricValue.radius.value)
    }
    public var center: Coordinates<T>? { value?.center }
    public var radius: T? { value?.radius }
  }
}
