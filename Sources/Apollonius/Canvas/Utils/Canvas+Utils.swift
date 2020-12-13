extension Canvas {
  func childrenKeys(_ item: Item) -> Set<ObjectIdentifier> {
    switch item {
    case let .circular(figure): return childrenKeys(figure)
    case let .scalar(figure): return childrenKeys(figure)
    case let .point(figure): return childrenKeys(figure)
    case let .intersection(figure): return childrenKeys(figure)
    case let .straight(figure): return childrenKeys(figure)
    }
  }
  
  func childrenKeys(_ key: ObjectIdentifier) -> Set<ObjectIdentifier> {
    return childrenKeys(items[key]!)
  }
  
  func childrenKeys<Figure: FigureProtocolInternal>(_ figure: Figure) -> Set<ObjectIdentifier> {
    return Set(figure.shape.children.map{ $0.key })
  }
  
  func children<Figure: FigureProtocolInternal>(_ figure: Figure) -> [Item] {
    return childrenKeys(figure).map{ items[$0]! }
  }
  
  func commonChildrenKeys<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1) -> Set<ObjectIdentifier> {
    return childrenKeys(figure0).intersection(childrenKeys(figure1))
  }
  
  func commonChildren<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1) -> [Item] {
    return commonChildrenKeys(figure0, figure1).map{ items[$0]! }
  }
  
  func commonChildrenKeys<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal, Figure2: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1, _ figure2: Figure2) -> Set<ObjectIdentifier> {
    return childrenKeys(figure0).intersection(childrenKeys(figure1)).intersection(childrenKeys(figure2))
  }
  
  func commonChildren<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal, Figure2: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1, _ figure2: Figure2) -> [Item] {
    return commonChildrenKeys(figure0, figure1, figure2).map{ items[$0]! }
  }
  
  static func sorted<Figure: FigureProtocolInternal>(_ s0: Figure, _ s1: Figure) -> (Figure, Figure) {
    guard s0.shape.index < s1.shape.index else { return (s1, s0) }
    return (s0, s1)
  }
  
  static func sorted<Figure: FigureProtocolInternal>(_ s0: Figure, _ s1: Figure, _ s2: Figure) -> (Figure, Figure, Figure) {
    let result = [s0, s1, s2].sorted { $0.shape.index <= $1.shape.index }
    return (result[0], result[1], result[2])
  }
}

extension Canvas {
  func knownPointsKeys<Figure: FigureProtocolInternal>(_ figure: Figure) -> Set<ObjectIdentifier> where Figure.S: GeometricCurveInternal {
    return Set(figure.shape.knownPoints.map{ $0.key })
  }
  
  func knownPoints<Figure: FigureProtocolInternal>(_ figure: Figure) -> [Point] where Figure.S: GeometricCurveInternal {
    return knownPointsKeys(figure).map{ items[$0]!.point! }
  }
  
  func commonKnownPointsKeys<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1) -> Set<ObjectIdentifier> where Figure0.S: GeometricCurveInternal, Figure1.S: GeometricCurveInternal {
    return knownPointsKeys(figure0).intersection(knownPointsKeys(figure1))
  }
  
  func commonKnownPoints<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1) -> [Point] where Figure0.S: GeometricCurveInternal, Figure1.S: GeometricCurveInternal {
    return commonKnownPointsKeys(figure0, figure1).map{ items[$0]!.point! }
  }
  
  func commonKnownPointsKeys<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal, Figure2: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1, _ figure2: Figure2) -> Set<ObjectIdentifier> where Figure0.S: GeometricCurveInternal, Figure1.S: GeometricCurveInternal, Figure2.S: GeometricCurveInternal {
    return knownPointsKeys(figure0).intersection(knownPointsKeys(figure1)).intersection(knownPointsKeys(figure2))
  }
  
  func commonKnownPoints<Figure0: FigureProtocolInternal, Figure1: FigureProtocolInternal, Figure2: FigureProtocolInternal>(_ figure0: Figure0, _ figure1: Figure1, _ figure2: Figure2) -> [Point] where Figure0.S: GeometricCurveInternal, Figure1.S: GeometricCurveInternal, Figure2.S: GeometricCurveInternal {
    return commonKnownPointsKeys(figure0, figure1, figure2).map{ items[$0]!.point! }
  }
}

extension Canvas {
  func knownCurvesKeys(_ point: Point) -> Set<ObjectIdentifier> {
    return Set(point.shape.knownCurves.map{ $0.key })
  }
  
  func knownCurves(_ point: Point) -> [Item] {
    return knownCurvesKeys(point).map{ items[$0]! }
  }
  
  func commonKnownCurvesKeys(_ points: [Point]) -> Set<ObjectIdentifier> {
    var result: Set<ObjectIdentifier>? = nil
    for point in points {
      result = result?.intersection(knownCurvesKeys(point))
    }
    return result ?? Set()
  }
  
  func commonKnownCurvesKeys(_ points: Point...) -> Set<ObjectIdentifier> {
    return commonKnownCurvesKeys(points)
  }
  
  func commonKnownCurves(_ points: Point...) -> [Item] {
    return commonKnownCurvesKeys(points).map{ items[$0]! }
  }
}

extension Canvas {
  func gatherKeys(from key: ObjectIdentifier) -> Set<ObjectIdentifier> {
    var gatheredKeys = Set<ObjectIdentifier>()
    gatherKeys(from: key, gatheredKeys: &gatheredKeys)
    return gatheredKeys
  }
  
  func gatherKeys(from key: ObjectIdentifier, gatheredKeys: inout Set<ObjectIdentifier>) {
    // Gathering the key itself
    gatheredKeys.insert(key)
    // Gathering child keys
    for child in childrenKeys(items[key]!) {
      guard !gatheredKeys.contains(child) else { continue }
      gatherKeys(from: child, gatheredKeys: &gatheredKeys)
    }
  }
}

