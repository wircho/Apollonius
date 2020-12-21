
public extension Canvas {
  enum Figure {
    case point(Point)
    case line(Line)
    case ray(Ray)
    case segment(Segment)
    case circle(Circle)
    case arc(Arc)
    case scalar(Scalar)
  }
  
  var allFigures: [Figure] {
    return items.values.compactMap{ $0.figure }
  }
  
  func forEachFigure(_ body: (Figure) -> Void) {
    items.keys.forEach {
      key in
      guard let figure = items.unorderedDictionary[key]!.figure else { return }
      body(figure)
    }
  }
}

extension Canvas.Item {
  var figure: Canvas.Figure? {
    switch self {
    case let .point(point): return .point(point)
    case let .line(line): return .line(line)
    case let .ray(ray): return .ray(ray)
    case let .segment(segment): return .segment(segment)
    case let .circle(circle): return .circle(circle)
    case let .arc(arc): return .arc(arc)
    case let .scalar(scalar): return .scalar(scalar)
    case .intersection: return nil
    }
  }
}
