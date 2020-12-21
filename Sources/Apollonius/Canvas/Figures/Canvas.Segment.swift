import Foundation
import Numerics

public extension Canvas {
  final class Segment: FigureProtocol {
    let storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Straight<T>, LineStyle, FigureMeta>) {
      self.storage = storage
    }
    
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
      public let tip: Coordinates
    }
    
    public var value: Value? {
      guard let geometricValue = shape.value else { return nil }
      return .init(origin: geometricValue.origin.toCanvas(), tip: geometricValue.tip.toCanvas())
    }
    public var origin: Coordinates? { value?.origin }
    public var tip: Coordinates? { value?.tip }
    public var slopeAngle: T? { shape.value?.angle?.value }
    public var length: T? { shape.value?.length.value }
  }
}
