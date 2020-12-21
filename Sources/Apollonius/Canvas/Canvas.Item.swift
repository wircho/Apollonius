extension Canvas {
  enum Item {
    case point(Point)
    case straight(Straight)
    case circular(Circular)
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
      case let figure as Canvas.Straight: self = .straight(figure)
      case let figure as Canvas.Circular: self = .circular(figure)
      case let figure as Canvas.Scalar: self = .scalar(figure)
      case let figure as Canvas.Intersection: self = .intersection(figure)
    default: return nil
    }
  }
  
  func update() {
    switch self {
    case let .point(figure): figure.shape.update()
    case let .straight(figure): figure.shape.update()
    case let .circular(figure): figure.shape.update()
    case let .scalar(figure): figure.shape.update()
    case let .intersection(figure): figure.shape.update()
    }
  }
}
