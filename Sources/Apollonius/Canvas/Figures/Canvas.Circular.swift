import Foundation
import Numerics

public extension Canvas {
  final class Circular: FigureProtocol {
    
    let storage: FigureProtocolStorage<Geometry.Circular<T>, CircularStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Circular<T>, CircularStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var style: CircularStyle {
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
  func circle(centeredAt center: Point, through tip: Point, style: CircularStyle = .init(), meta: FigureMeta = .init()) -> Circular {
    for item in commonChildren(center, tip) {
      guard case let .circular(circular) = item else { continue }
      guard case let ._between(otherCenter, otherArm) = circular.shape.parameters else { continue }
      guard otherCenter == center.shape, otherArm == tip.shape else { continue }
      return circular
    }
    // Creating shape
    let shape = Geometry.Circular.centered(at: center.shape, through: tip.shape)
    // TODO:
    // 1. Make undoManager optional. Maybe a boolean whether to support undo or not. Maybe simply not suppporting undo registration is enough? But then this condition cannot block actions? So this is not a proper way to block actions?
    // 2. Some objects need to be completely quiet. That would mean they block undo actions for as long as they live, and they unblock them when they disappear. How do we police this? What if one of them stays alive forever, will undo actions fail? How do we make all actions fail?
    // 3. Any use case where not disappearing is useful? Seems very dangerous! What if their ancestors get removed?
    // 4. An alternative is to have them mirror an existing object weakly, so it has a weak reference but it's not an ancestor, and it can be a quier object because it has not ancestors. And only objects with no non-quiet ancestors can be quiet. I LIKE THIS.
    // 5. Make objects forward their style and meta changes to the undo manager. So they need a weak reference to the undo manager. THIS MEANS YOU SHOULD NO BE ABLE TO TURN UNDO ON AND OFF ANYTIME. THAT'S OK!
    let circular = Circular(shape, style: style, meta: meta, canvas: self)
    add(circular)
    return circular
  }
  
  func circle(centeredAt center: Point, radius: Scalar, style: CircularStyle = .init(), meta: FigureMeta = .init()) -> Circular {
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
  
  func circumcircle(_ unsortedPoint0: Point, _ unsortedPoint1: Point, _ unsortedPoint2: Point, style: CircularStyle = .init(), meta: FigureMeta = .init()) -> Circular {
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
  
  func arcCircumscribing(_ point0: Point, _ point1: Point, _ point2: Point, style: CircularStyle = .init(), meta: FigureMeta = .init()) -> Circular {
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
