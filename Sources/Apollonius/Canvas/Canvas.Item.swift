extension Canvas {
  enum Item {
    case point(Point)
    case line(Line)
    case ray(Ray)
    case segment(Segment)
    case circle(Circle)
    case arc(Arc)
    case scalar(Scalar)
    case intersection(Intersection)
  }
}

extension Canvas.Item {
  var point: Canvas.Point? {
    guard case let .point(point) = self else { return nil }
    return point
  }
  
  init?<Figure: FigureProtocolInternal>(_ figure: Figure) {
    switch figure {
    case let figure as Canvas.Point: self = .point(figure)
    case let figure as Canvas.Line: self = .line(figure)
    case let figure as Canvas.Ray: self = .ray(figure)
    case let figure as Canvas.Segment: self = .segment(figure)
    case let figure as Canvas.Circle: self = .circle(figure)
    case let figure as Canvas.Arc: self = .arc(figure)
    case let figure as Canvas.Scalar: self = .scalar(figure)
    case let figure as Canvas.Intersection: self = .intersection(figure)
    default: return nil
    }
  }
  
  func update() {
    switch self {
    case let .point(figure): figure.shape.update()
    case let .line(figure): figure.shape.update()
    case let .ray(figure): figure.shape.update()
    case let .segment(figure): figure.shape.update()
    case let .circle(figure): figure.shape.update()
    case let .arc(figure): figure.shape.update()
    case let .scalar(figure): figure.shape.update()
    case let .intersection(figure): figure.shape.update()
    }
  }
}
