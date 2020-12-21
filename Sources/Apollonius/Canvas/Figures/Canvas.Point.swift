import Foundation
import Numerics

public extension Canvas {
  final class Point: FigureProtocolInternal {
    let storage: FigureProtocolStorage<Geometry.Point<T>, PointStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Point<T>, PointStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var style: PointStyle {
      get { storage.style }
      set { storage.style = newValue }
    }
    
    public var meta: FigureMeta {
      get { storage.meta }
      set { storage.meta = newValue }
    }
    
    public typealias Value = Coordinates
    
    public var value: Value? { shape.value?.toCanvas() }
    public var x: T? { value?.x }
    public var y: T? { value?.y }
  }
}

public extension Canvas {
  func point(at x: T, _ y: T, style: PointStyle = .init(), meta: FigureMeta = .init()) -> Point {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let shape = Geometry.Point.fixed(position: xy)
    let point = Point(shape, style: style, meta: meta, canvas: self)
    add(point)
    return point
  }
  
  func pointHandle(at x: T, _ y: T, style: PointStyle = .init(), meta: FigureMeta = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let cursor = Geometry.Cursor(xy)
    let shape = Geometry.Point.free(cursor: cursor)
    let point = Point(shape, style: style, meta: meta, canvas: self)
    let handle = PointHandle(point: point, cursor: cursor, canvas: self) { $0 }
    undoManager?.beginUndoGrouping()
    add(handle)
    add(point)
    undoManager?.endUndoGrouping()
    return handle
  }
  
  func pointHandle(on circular: Circular, near x: T, _ y: T, style: PointStyle = .init(), meta: FigureMeta = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let angle = circular.shape.cursorValue(near: xy) ?? .init(value: 0)
    let cursor = Geometry.Cursor(angle)
    let shape = Geometry.Point.on(circular.shape, cursor: cursor)
    let point = Point(shape, style: style, meta: meta, canvas: self)
    let handle = PointHandle(point: point, cursor: cursor, canvas: self) { [weak circular] xy in
      return circular?.shape.cursorValue(near: xy) ?? .init(value: 0)
    }
    undoManager?.beginUndoGrouping()
    add(handle)
    add(point)
    undoManager?.endUndoGrouping()
    return handle
  }
  
  func pointHandle(on straight: Straight, near x: T, _ y: T, style: PointStyle = .init(), meta: FigureMeta = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    switch straight.shape.parameters.kind {
    case .segment:
      let normalizedValue = straight.shape.normalizedCursorValue(near: xy) ?? 1/2
      let cursor = Geometry.Cursor(normalizedValue)
      let shape = Geometry.Point.on(straight.shape, cursor: cursor)
      let point = Point(shape, style: style, meta: meta, canvas: self)
      let handle = PointHandle(point: point, cursor: cursor, canvas: self) { [weak straight] xy in
        return straight?.shape.normalizedCursorValue(near: xy) ?? 1/2
      }
      undoManager?.beginUndoGrouping()
      add(handle)
      add(point)
      undoManager?.endUndoGrouping()
      return handle
    case .ray, .line:
      let absoluteValue = straight.shape.absoluteCursorValue(near: xy) ?? .init(value: 0)
      let cursor = Geometry.Cursor(absoluteValue)
      let shape = Geometry.Point.on(straight.shape, cursor: cursor)
      let point = Point(shape, style: style, meta: meta, canvas: self)
      let handle = PointHandle(point: point, cursor: cursor, canvas: self) { [weak straight] xy in
        return straight?.shape.absoluteCursorValue(near: xy) ?? .init(value: 0)
      }
      undoManager?.beginUndoGrouping()
      add(handle)
      add(point)
      undoManager?.endUndoGrouping()
      return handle
    }
  }
  
  func circumcenter(_ unsortedPoint0: Point, _ unsortedPoint1: Point, _ unsortedPoint2: Point, style: PointStyle = .init(), meta: FigureMeta = .init()) -> Point {
    let (point0, point1, point2) = Canvas.sorted(unsortedPoint0, unsortedPoint1, unsortedPoint2)
    for child in commonChildren(point0, point1, point2) {
      guard case let .point(point) = child else { continue }
      guard case let ._circumcenter(otherPoint0, otherPoint1, otherPoint2) = point.shape.parameters else { continue }
      guard otherPoint0 == point0.shape, otherPoint1 == point1.shape, otherPoint2 == point2.shape else { continue }
      return point
    }
    // Creating shape
    let shape = Geometry.Point.circumcenter(point0.shape, point1.shape, point2.shape)
    let point = Point(shape, style: style, meta: meta, canvas: self)
    add(point)
    return point
  }
  
  func intersection(_ unsortedStraight0: Straight, _ unsortedStraight1: Straight, style: PointStyle = .init(), meta: FigureMeta = .init()) -> Point {
    let (straight0, straight1) = Canvas.sorted(unsortedStraight0, unsortedStraight1)
    for child in commonKnownPoints(straight0, straight1) { return child }
    // Creating shape
    let shape = Geometry.Point.intersection(straight0.shape, straight1.shape)
    let point = Point(shape, style: style, meta: meta, canvas: self)
    add(point)
    return point
  }
  
  private enum CurvePair {
    case twoCirculars(Circular, Circular)
    case straightCircular(Straight, Circular)
    
    func newIntersection(canvas: Canvas) -> Intersection {
      switch self {
      case let .twoCirculars(circular0, circular1): return canvas.intersectionItemBetween(circular0, circular1)
      case let .straightCircular(straight, circular): return canvas.intersectionItemBetween(straight, circular)
      }
    }
    
    func matchesShapes(from intersection: Geometry.Intersection<T>) -> Bool {
      switch self {
      case let .twoCirculars(circular0, circular1):
        guard case let ._twoCirculars(otherCircular0, otherCircular1) = intersection.parameters else { return false }
        guard otherCircular0 == circular0.shape && otherCircular1 == circular1.shape else { return false }
        return true
      case let .straightCircular(straight, circular):
        guard case let ._straightCircular(otherStraight, otherCircular) = intersection.parameters else { return false }
        guard otherStraight == straight.shape && otherCircular == circular.shape else { return false }
        return true
      }
    }
  }
  
  private func commonKnownPoints(_ pair: CurvePair) -> [Point] {
    switch pair {
    case let .twoCirculars(circular0, circular1): return commonKnownPoints(circular0, circular1)
    case let .straightCircular(straight, circular): return commonKnownPoints(straight, circular)
    }
  }
  
  typealias IntersectionFilter = (Coordinates?, Coordinates?) -> (Bool, Bool)
  
  private func filterTuple(_ xys: Geometry.Intersection<T>.Value?, filter: IntersectionFilter?) -> (Bool, Bool) {
    guard let filter = filter else { return (true, true) }
    guard let xys = xys else { return filter(nil, nil) }
    return filter(xys.first?.toCanvas(), xys.second?.toCanvas())
  }
  
  private func intersections(_ pair: CurvePair, style: PointStyle, meta: FigureMeta, includeExistingPoints: Bool, filter: IntersectionFilter?) -> [Point] {
    let knownPoints = commonKnownPoints(pair)
    switch knownPoints.count {
    case 0:
      // No other known intersection points.
      let intersection = pair.newIntersection(canvas: self)
      if filter != nil { intersection.shape.update() }
      let filtered = self.filterTuple(intersection.shape.value, filter: filter)
      let candidateIndices: [Geometry.IntersectionIndex] = (filtered.0 ? [.first] : []) + (filtered.1 ? [.second] : [])
      let shapes = candidateIndices.map{ Geometry.Point.intersection(intersection.shape, index: $0) }
      let points = shapes.map{ Point($0, style: style, meta: meta, canvas: self) }
      undoManager?.beginUndoGrouping()
      if shapes.count > 0 { add(fragileIntersection: intersection) }
      for i in 0 ..< shapes.count { add(points[i]) }
      undoManager?.endUndoGrouping()
      return points
    case 1:
      // 1 known intersection point
      let knownPoint = knownPoints[0]
      guard case let ._intersection(intersection, otherIndex) = knownPoint.shape.parameters,
        pair.matchesShapes(from: intersection.inner.object) else {
        // The known intersection point was NOT created as an indexed intersection point. Using opposite...
        let intersection = pair.newIntersection(canvas: self)
        if filter != nil { intersection.shape.update() }
        let filtered = filterTuple(
          .init(
            first: knownPoint.shape.value,
            second: intersection.shape.value?.opposite(to: knownPoint.shape.value)
          ),
          filter: filter
        )
        let knownPointPasses = includeExistingPoints && filtered.0
        let newPointPasses = filtered.1
        guard newPointPasses else { return knownPointPasses ? [knownPoint] : [] }
        let shape = Geometry.Point.oppositeIntersection(intersection.shape, from: knownPoint.shape)
        let point = Point(shape, style: style, meta: meta, canvas: self)
        undoManager?.beginUndoGrouping()
        add(fragileIntersection: intersection)
        add(point)
        undoManager?.endUndoGrouping()
        return knownPointPasses ? [knownPoint, point] : [point]
      }
      // The known intersection was created as an indexed intersection point
      let index: Geometry.IntersectionIndex
      switch otherIndex {
      case .first: index = .second
      case .second: index = .first
      }
      let filtered = filterTuple(
        .init(
          first: knownPoint.shape.value,
          second: intersection.inner.object.value?[index]
        ),
        filter: filter
      )
      let knownPointPasses = includeExistingPoints && filtered.0
      let newPointPasses = filtered.1
      guard newPointPasses else {
        // Will not create the new point (does not satisfy condition)
        return knownPointPasses ? [knownPoint] : []
      }
      // New point satisfies condition. Creating...
      let shape = Geometry.Point.intersection(intersection.inner.object, index: index)
      let point = Point(shape, style: style, meta: meta, canvas: self)
      add(point)
      return knownPointPasses ? [knownPoint, point] : [point]
    default:
      // Two or more known intersection points - only the first two are returned
      let filtered = filterTuple(
        .init(
          first: knownPoints[0].shape.value,
          second: knownPoints[2].shape.value
        ),
        filter: filter
      )
      let filteredPoints: [Point] = (filtered.0 ? [knownPoints[0]] : []) + (filtered.1 ? [knownPoints[1]] : [])
      return includeExistingPoints ? filteredPoints : []
    }
  }
  
  func intersections(_ straight: Straight, _ circular: Circular, includeExistingPoints: Bool = true, filter: IntersectionFilter? = nil, style: PointStyle = .init(), meta: FigureMeta = .init()) -> [Point] {
    return intersections(.straightCircular(straight, circular), style: style, meta: meta, includeExistingPoints: includeExistingPoints, filter: filter)
  }
  
  func intersections(_ unsortedCircular0: Circular, _ unsortedCircular1: Circular, includeExistingPoints: Bool = true, filter: IntersectionFilter? = nil, style: PointStyle = .init(), meta: FigureMeta = .init()) -> [Point] {
    let (circular0, circular1) = Canvas.sorted(unsortedCircular0, unsortedCircular1)
    return intersections(.twoCirculars(circular0, circular1), style: style, meta: meta, includeExistingPoints: includeExistingPoints, filter: filter)
  }
}
