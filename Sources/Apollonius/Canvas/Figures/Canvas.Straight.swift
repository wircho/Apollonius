import Foundation
import Numerics

public extension Canvas {
  private func straight<StraightType: LineOrRayOrSegmentInternal>(_ unsortedOrigin: Point, _ unsortedTip: Point, style: LineStyle = .init(), meta: FigureMeta = .init()) -> StraightType where StraightType.T == T, StraightType.Specifier == Specifier, StraightType.Style == LineStyle, StraightType.Meta == FigureMeta {
    for child in commonChildren(unsortedOrigin, unsortedTip) {
      let optionalChildFigure: StraightType?
      let childShape: Geometry.Straight<T>
      switch child {
      case let .line(figure):
        optionalChildFigure = figure as? StraightType
        childShape = figure.shape
      case let .ray(figure):
        optionalChildFigure = figure as? StraightType
        childShape = figure.shape
      case let .segment(figure):
        optionalChildFigure = figure as? StraightType
        childShape = figure.shape
      case .arc, .circle, .scalar, .intersection, .point: continue
      }
      guard let childFigure = optionalChildFigure else { continue }
      guard case let ._between(otherOrigin, otherTip) = childShape.parameters.definition else { continue }
      let condition: Bool
      switch StraightType.kind {
      case .segment, .line: condition = (otherOrigin == unsortedOrigin.shape && otherTip == unsortedTip.shape) || (otherTip == unsortedOrigin.shape && otherOrigin == unsortedTip.shape)
      case .ray: condition = otherOrigin == unsortedOrigin.shape && otherTip == unsortedTip.shape
      }
      guard condition else { continue }
      return childFigure
    }
    // Creating shape
    let origin: Point
    let tip: Point
    switch StraightType.kind {
    case .segment, .line: (origin, tip) = Canvas.sorted(unsortedOrigin, unsortedTip)
    case .ray: (origin, tip) = (unsortedOrigin, unsortedTip)
    }
    let shape = Geometry.Straight<T>.straight(StraightType.kind, origin.shape, tip.shape)
    let figure = StraightType(shape, style: style, meta: meta, canvas: self)
    add(figure)
    return figure
  }
  
  func segment(_ origin: Point, _ tip: Point, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Segment {
    return straight(origin, tip, style: style, meta: meta)
  }
  
  func line(_ origin: Point, _ tip: Point, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Line {
    return straight(origin, tip, style: style, meta: meta)
  }
  
  func ray(_ origin: Point, _ tip: Point, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Ray {
    return straight(origin, tip, style: style, meta: meta)
  }
  
  private func directedLine(_ direction: Geometry.StraightDirection, from origin: Point, to other: Geometry.Straight<T>, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Line {
    for child in commonChildren(origin.shape, other) {
      guard case let .line(line) = child else { continue }
      guard case let ._directed(childDirection, childOrigin, childOther) = line.shape.parameters.definition else { continue }
      guard childDirection == direction && childOrigin == origin.shape && childOther == other else { continue }
      return line
    }
    // Creating shape
    let shape = Geometry.Straight<T>.directed(direction, origin: origin.shape, other: other)
    let line = Line(shape, style: style, meta: meta, canvas: self)
    add(line)
    return line
  }
  
  func parallelLine<Figure: LineOrRayOrSegment>(from origin: Point, to figure: Figure, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Line where Figure.T == T {
    return directedLine(.parallel, from: origin, to: figure.internalRepresentation.shape, style: style, meta: meta)
  }
  
  func perpendicularLine<Figure: LineOrRayOrSegment>(from origin: Point, to figure: Figure, style: LineStyle = .init(), meta: FigureMeta = .init()) -> Line where Figure.T == T {
    return directedLine(.perpendicular, from: origin, to: figure.internalRepresentation.shape, style: style, meta: meta)
  }
  
}

