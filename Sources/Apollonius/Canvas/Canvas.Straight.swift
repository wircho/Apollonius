import Numerics

public extension Canvas {
  typealias Straight = Figure<Geometry.Straight<T>, StraightStyle>
}

public extension Canvas {
  private func straight(_ kind: Geometry.StraightKind, _ unsortedOrigin: Point, _ unsortedTip: Point, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
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
    let straight = Straight(shape, style: style, info: info)
    add(straight)
    return straight
  }
  
  func segment(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    return straight(.segment, origin, tip, style: style, info: info)
  }
  
  func line(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    return straight(.line, origin, tip, style: style, info: info)
  }
  
  func ray(_ origin: Point, _ tip: Point, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    return straight(.ray, origin, tip, style: style, info: info)
  }
  
  func directedLine(_ direction: Geometry.StraightDirection, from origin: Point, to other: Straight, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    for child in commonChildren(origin, other) {
      guard case let .straight(straight) = child else { continue }
      guard straight.shape.parameters.kind == .line else { continue }
      guard case let ._directed(childDirection, childOrigin, childOther) = straight.shape.parameters.definition else { continue }
      guard childDirection == direction && childOrigin == origin.shape && childOther == other.shape else { continue }
      return straight
    }
    // Creating shape
    let shape = Geometry.Straight<T>.directed(direction, origin: origin.shape, other: other.shape)
    let straight = Straight(shape, style: style, info: info)
    add(straight)
    return straight
  }
  
  func parallelLine(from origin: Point, to straight: Straight, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    return directedLine(.parallel, from: origin, to: straight, style: style, info: info)
  }
  
  func perpendicularLine(from origin: Point, to straight: Straight, style: StraightStyle = .init(), info: Info = .init()) -> Straight {
    return directedLine(.perpendicular, from: origin, to: straight, style: style, info: info)
  }
}

