import Foundation
import Numerics

public extension Canvas {
  func circle(centeredAt center: Point, through tip: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circle {
    for item in commonChildren(center, tip) {
      guard case let .circle(circle) = item else { continue }
      guard case let ._between(otherCenter, otherArm) = circle.shape.parameters else { continue }
      guard otherCenter == center.shape, otherArm == tip.shape else { continue }
      return circle
    }
    // Creating shape
    let shape = Geometry.Circular.centered(at: center.shape, through: tip.shape)
    let circle = Circle(shape, style: style, meta: meta, canvas: self)
    add(circle)
    return circle
  }
  
  func circle(centeredAt center: Point, radius: Scalar, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circle {
    for item in commonChildren(center, radius) {
      guard case let .circle(circle) = item else { continue }
      guard case let ._with(otherCenter, otherRadius) = circle.shape.parameters else { continue }
      guard otherCenter == center.shape, otherRadius == radius.shape else { continue }
      return circle
    }
    // Creating shape
    let shape = Geometry.Circular.centered(at: center.shape, radius: radius.shape)
    let circle = Circle(shape, style: style, meta: meta, canvas: self)
    add(circle)
    return circle
  }
  
  func circumcircle(_ unsortedPoint0: Point, _ unsortedPoint1: Point, _ unsortedPoint2: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Circle {
    let (point0, point1, point2) = Canvas.sorted(unsortedPoint0, unsortedPoint1, unsortedPoint2)
    for item in commonKnownCurves(point0, point1, point2) {
      guard case let .circle(circle) = item else { continue }
      return circle
    }
    // Creating shape
    let shape = Geometry.Circular.circumscribing(point0.shape, point1.shape, point2.shape)
    let circle = Circle(shape, style: style, meta: meta, canvas: self)
    add(circle)
    return circle
  }
  
  func arcCircumscribing(_ point0: Point, _ point1: Point, _ point2: Point, style: CurveStyle = .init(), meta: FigureMeta = .init()) -> Arc {
    for item in commonKnownCurves(point0, point1, point2) {
      guard case let .arc(arc) = item else { continue }
      guard case let ._arc(otherPoint0, otherPoint1, otherPoint2) = arc.shape.parameters else { continue }
      guard otherPoint0 == point0.shape, otherPoint1 == point1.shape, otherPoint2 == point2.shape else { continue }
      return arc
    }
    // Creating shape
    let shape = Geometry.Circular.arcCircumscribing(point0.shape, point1.shape, point2.shape)
    let arc = Arc(shape, style: style, meta: meta, canvas: self)
    add(arc)
    return arc
  }
}
