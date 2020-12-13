import Numerics

public extension Canvas {
  final class Straight: FigureProtocolInternal {
    public enum Kind {
      case segment, ray, line
    }
    
    public struct Value {
      public let origin: Coordinates
      public let tip: Coordinates
    }
    
    typealias Shape = Geometry.Straight<T>
    public typealias Style = Canvas.StraightStyle
    public typealias Meta = Canvas.FigureMeta
    
    let shape: Shape
    public var style: Style
    public var meta: Meta
    
    public var value: Value? {
      guard let geometricValue = shape.value else { return nil }
      return .init(origin: geometricValue.origin.toCanvas(), tip: geometricValue.tip.toCanvas())
    }
    public var origin: Coordinates? { value?.origin }
    public var tip: Coordinates? { value?.tip }
    public var slopeAngle: T? {
      guard let geometricValue = shape.value else { return nil }
      return geometricValue.angle?.value
    }
    
    public var kind: Kind {
      switch shape.parameters.kind {
      case .segment: return .segment
      case .ray: return .ray
      case .line: return .line
      }
    }
    
    init(_ shape: Shape, style: Style, meta: Meta) {
      self.shape = shape
      self.style = style
      self.meta = meta
    }
  }
}

public extension Canvas {
  private func straight(_ kind: Geometry.StraightKind, _ unsortedOrigin: Point, _ unsortedTip: Point, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    for child in commonChildren(unsortedOrigin, unsortedTip) {
      guard case let .straight(straight) = child else { continue }
      guard case let ._between(otherOrigin, otherTip) = straight.shape.parameters.definition else { continue }
      guard straight.shape.parameters.kind == kind else { continue }
      let condition: Bool
      switch kind {
      case .segment, .line: condition = (otherOrigin == unsortedOrigin.shape && otherTip == unsortedTip.shape) || (otherTip == unsortedOrigin.shape && otherOrigin == unsortedTip.shape)
      case .ray: condition = otherOrigin == unsortedOrigin.shape && otherTip == unsortedTip.shape
      }
      guard condition else { continue }
      return straight
    }
    // Creating shape
    let origin: Point
    let tip: Point
    switch kind {
    case .segment, .line: (origin, tip) = Canvas.sorted(unsortedOrigin, unsortedTip)
    case .ray: (origin, tip) = (unsortedOrigin, unsortedTip)
    }
    let shape = Geometry.Straight<T>.straight(kind, origin.shape, tip.shape)
    let straight = Straight(shape, style: style, meta: meta)
    add(straight)
    return straight
  }
  
  func segment(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    return straight(.segment, origin, tip, style: style, meta: meta)
  }
  
  func line(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    return straight(.line, origin, tip, style: style, meta: meta)
  }
  
  func ray(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    return straight(.ray, origin, tip, style: style, meta: meta)
  }
  
  private func directedLine(_ direction: Geometry.StraightDirection, from origin: Point, to other: Straight, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    for child in commonChildren(origin, other) {
      guard case let .straight(straight) = child else { continue }
      guard straight.shape.parameters.kind == .line else { continue }
      guard case let ._directed(childDirection, childOrigin, childOther) = straight.shape.parameters.definition else { continue }
      guard childDirection == direction && childOrigin == origin.shape && childOther == other.shape else { continue }
      return straight
    }
    // Creating shape
    let shape = Geometry.Straight<T>.directed(direction, origin: origin.shape, other: other.shape)
    let straight = Straight(shape, style: style, meta: meta)
    add(straight)
    return straight
  }
  
  func parallelLine(from origin: Point, to straight: Straight, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    return directedLine(.parallel, from: origin, to: straight, style: style, meta: meta)
  }
  
  func perpendicularLine(from origin: Point, to straight: Straight, style: StraightStyle = .init(), meta: FigureMeta = .init()) -> Straight {
    return directedLine(.perpendicular, from: origin, to: straight, style: style, meta: meta)
  }
}

