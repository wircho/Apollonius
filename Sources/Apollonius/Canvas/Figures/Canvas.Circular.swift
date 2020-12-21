import Foundation
import Numerics

public extension Canvas {
  final class Circular: FigureProtocolInternal {
    
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

public extension Canvas {
  func circle(centeredAt center: Point, through tip: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circular {
    for item in commonChildren(center, tip) {
      guard case let .circular(circular) = item else { continue }
      guard case let ._between(otherCenter, otherArm) = circular.shape.parameters else { continue }
      guard otherCenter == center.shape, otherArm == tip.shape else { continue }
      return circular
    }
    // Creating shape
    let shape = Geometry.Circular.centered(at: center.shape, through: tip.shape)
    let circular = Circular(shape, style: style, meta: meta, canvas: self)
    add(circular)
    return circular
  }
  
  func circle(centeredAt center: Point, radius: Scalar, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circular {
    for item in commonChildren(center, radius) {
      guard case let .circular(circular) = item else { continue }
      guard case let ._with(otherCenter, otherRadius) = circular.shape.parameters else { continue }
      guard otherCenter == center.shape, otherRadius == radius.shape else { continue }
      return circular
    }
    // Creating shape
    let shape = Geometry.Circular.centered(at: center.shape, radius: radius.shape)
    let circular = Circular(shape, style: style, meta: meta, canvas: self)
    add(circular)
    return circular
  }
  
  func circumcircle(_ unsortedPoint0: Point, _ unsortedPoint1: Point, _ unsortedPoint2: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circular {
    let (point0, point1, point2) = Canvas.sorted(unsortedPoint0, unsortedPoint1, unsortedPoint2)
    for item in commonKnownCurves(point0, point1, point2) {
      guard case let .circular(circular) = item else { continue }
      return circular
    }
    // Creating shape
    let shape = Geometry.Circular.circumscribing(point0.shape, point1.shape, point2.shape)
    let circular = Circular(shape, style: style, meta: meta, canvas: self)
    add(circular)
    return circular
  }
  
  func arcCircumscribing(_ point0: Point, _ point1: Point, _ point2: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circular {
    for item in commonKnownCurves(point0, point1, point2) {
      guard case let .circular(circular) = item else { continue }
      guard case let ._arc(otherPoint0, otherPoint1, otherPoint2) = circular.shape.parameters else { continue }
      guard otherPoint0 == point0.shape, otherPoint1 == point1.shape, otherPoint2 == point2.shape else { continue }
      return circular
    }
    // Creating shape
    let shape = Geometry.Circular.arcCircumscribing(point0.shape, point1.shape, point2.shape)
    let circular = Circular(shape, style: style, meta: meta, canvas: self)
    add(circular)
    return circular
  }
}
