import Foundation
import Numerics

public extension Canvas {
  final class Arc: FigureProtocol {
    
    let storage: FigureProtocolStorage<Geometry.Circular<T>, CurveStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Circular<T>, CurveStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var style: CurveStyle {
      get { storage.style }
      set { storage.style = newValue }
    }
    
    public var meta: FigureMeta {
      get { storage.meta }
      set { storage.meta = newValue }
    }
    
    public struct Value {
      public let center: Coordinates
      public let radius: T
      public let angleInterval: AngleInterval?
    }
    
    public var value: Value? {
      guard let geometricValue = shape.value else { return nil }
      return .init(center: geometricValue.center.toCanvas(), radius: geometricValue.radius.value, angleInterval: geometricValue.interval?.toCanvas())
    }
    
    public var center: Coordinates? { value?.center }
    public var radius: T? { value?.radius }
    public var angleInterval: AngleInterval? { value?.angleInterval }
  }
}
