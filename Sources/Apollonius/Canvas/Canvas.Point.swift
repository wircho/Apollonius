import Numerics

public extension Canvas {
  typealias Point = Figure<Geometry.Point<T>, PointStyle>
}

public extension Canvas {
  func point(at x: T, _ y: T, style: PointStyle = .init(), info: Info = .init()) -> Point {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let shape = Geometry.Point.fixed(position: xy)
    let point = Point(shape, style: style, info: info)
    add(point)
    return point
  }
  
  func pointHandle(at x: T, _ y: T, style: PointStyle = .init(), info: Info = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let cursor = Geometry.Cursor(xy)
    let shape = Geometry.Point.free(cursor: cursor)
    let point = Point(shape, style: style, info: info)
    let handle = PointHandle(point: point, cursor: cursor) { $0 }
    add(handle)
    add(point)
    return handle
  }
  
  func pointHandle(on circular: Circular, near x: T, _ y: T, style: PointStyle = .init(), info: Info = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    let angle = circular.shape.cursorValue(near: xy) ?? .init(value: 0)
    let cursor = Geometry.Cursor(angle)
    let shape = Geometry.Point.on(circular.shape, cursor: cursor)
    let point = Point(shape, style: style, info: info)
    let handle = PointHandle(point: point, cursor: cursor) { [weak circular] xy in
      return circular?.shape.cursorValue(near: xy) ?? .init(value: 0)
    }
    add(handle)
    add(point)
    return handle
  }
  
  func pointHandle(on straight: Straight, near x: T, _ y: T, style: PointStyle = .init(), info: Info = .init()) -> PointHandle {
    let xy = XY(x: .init(value: x), y: .init(value: y))
    switch straight.shape.parameters.kind {
    case .segment:
      let normalizedValue = straight.shape.normalizedCursorValue(near: xy) ?? 1/2
      let cursor = Geometry.Cursor(normalizedValue)
      let shape = Geometry.Point.on(straight.shape, cursor: cursor)
      let point = Point(shape, style: style, info: info)
      let handle = PointHandle(point: point, cursor: cursor) { [weak straight] xy in
        return straight?.shape.normalizedCursorValue(near: xy) ?? 1/2
      }
      add(handle)
      add(point)
      return handle
    case .ray, .line:
      let absoluteValue = straight.shape.absoluteCursorValue(near: xy) ?? .init(value: 0)
      let cursor = Geometry.Cursor(absoluteValue)
      let shape = Geometry.Point.on(straight.shape, cursor: cursor)
      let point = Point(shape, style: style, info: info)
      let handle = PointHandle(point: point, cursor: cursor) { [weak straight] xy in
        return straight?.shape.absoluteCursorValue(near: xy) ?? .init(value: 0)
      }
      add(handle)
      add(point)
      return handle
    }
  }
  
  func circumcenter(_ unsortedPoint0: Point, _ unsortedPoint1: Point, _ unsortedPoint2: Point, style: PointStyle = .init(), info: Info = .init()) -> Point {
    let (point0, point1, point2) = Canvas.sorted(unsortedPoint0, unsortedPoint1, unsortedPoint2)
    for child in commonChildren(point0, point1, point2) {
      guard case let .point(point) = child else { continue }
      guard case let ._circumcenter(otherPoint0, otherPoint1, otherPoint2) = point.shape.parameters else { continue }
      guard otherPoint0 == point0.shape, otherPoint1 == point1.shape, otherPoint2 == point2.shape else { continue }
      return point
    }
    // Creating shape
    let shape = Geometry.Point.circumcenter(point0.shape, point1.shape, point2.shape)
    let point = Point(shape, style: style, info: info)
    add(point)
    return point
  }
  
  func intersection(_ unsortedStraight0: Straight, _ unsortedStraight1: Straight, style: PointStyle = .init(), info: Info = .init()) -> Point {
    let (straight0, straight1) = Canvas.sorted(unsortedStraight0, unsortedStraight1)
    for child in commonKnownPoints(straight0, straight1) { return child }
    // Creating shape
    let shape = Geometry.Point.intersection(straight0.shape, straight1.shape)
    let point = Point(shape, style: style, info: info)
    add(point)
    return point
  }
  
  private func satisfies(_ condition: ((XY<T>?) -> Bool)?, _ xy: XY<T>?) -> Bool {
    guard let condition = condition else { return true }
    return condition(xy)
  }
  
  private enum CurvePair {
    case twoCirculars(Circular, Circular)
    case straightCircular(Straight, Circular)
    
    func newIntersection() -> Intersection {
      switch self {
      case let .twoCirculars(circular0, circular1): return Canvas.intersectionItemBetween(circular0, circular1)
      case let .straightCircular(straight, circular): return Canvas.intersectionItemBetween(straight, circular)
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
  
  private func intersections(_ pair: CurvePair, style: PointStyle, info: Info, includeExistingPoints: Bool, condition: ((XY<T>?) -> Bool)?) -> [Point] {
    let knownPoints = commonKnownPoints(pair)
    switch knownPoints.count {
    case 0:
      // No other known intersection points.
      let intersection = pair.newIntersection()
      if condition != nil { intersection.shape.update() }
      let candidateIndices = [.first, .second].filter { satisfies(condition, intersection.shape.value?[$0]) }
      let shapes = candidateIndices.map{ Geometry.Point.intersection(intersection.shape, index: $0) }
      let points = shapes.map{ Point($0, style: style, info: info) }
      if shapes.count > 0 { add(intersection) }
      for i in 0 ..< shapes.count { add(points[i]) }
      return points
    case 1:
      // 1 known intersection point
      let knownPoint = knownPoints[0]
      let knownPointSatisfiesCondition = includeExistingPoints && satisfies(condition, knownPoint.shape.value)
      guard case let ._intersection(intersection, otherIndex) = knownPoint.shape.parameters,
        pair.matchesShapes(from: intersection.inner.object) else {
          // The known intersection point was NOT created as an indexed intersection point. Using opposite...
          let intersection = pair.newIntersection()
          if condition != nil { intersection.shape.update() }
          let newPointSatisfiesCondition = satisfies(condition, intersection.shape.value?.opposite(to: knownPoint.shape.value))
          guard newPointSatisfiesCondition else { return knownPointSatisfiesCondition ? [knownPoint] : [] }
          let shape = Geometry.Point.oppositeIntersection(intersection.shape, from: knownPoint.shape)
          let point = Point(shape, style: style, info: info)
          add(intersection)
          add(point)
          return knownPointSatisfiesCondition ? [knownPoint, point] : [point]
      }
      // The known intersection was created as an indexed intersection point
      let index: Geometry.IntersectionIndex
      switch otherIndex {
      case .first: index = .second
      case .second: index = .first
      }
      let newPointSatisfiesCondition = satisfies(condition, intersection.inner.object.value?[index])
      guard newPointSatisfiesCondition else {
        // Will not create the new point (does not satisfy condition)
        return knownPointSatisfiesCondition ? [knownPoint] : []
      }
      // New point satisfies condition. Creating...
      let shape = Geometry.Point.intersection(intersection.inner.object, index: index)
      let point = Point(shape, style: style, info: info)
      add(point)
      return knownPointSatisfiesCondition ? [knownPoint, point] : [point]
    default:
      // Two or more known intersection points
      return includeExistingPoints ? knownPoints.filter{ satisfies(condition, $0.shape.value) } : []
    }
  }
  
  func intersections(_ straight: Straight, _ circular: Circular, style: PointStyle = .init(), info: Info = .init(), includeExistingPoints: Bool = true, condition: ((XY<T>?) -> Bool)? = nil) -> [Point] {
    return intersections(.straightCircular(straight, circular), style: style, info: info, includeExistingPoints: includeExistingPoints, condition: condition)
  }
  
  func intersections(_ unsortedCircular0: Circular, _ unsortedCircular1: Circular, style: PointStyle = .init(), info: Info = .init(), includeExistingPoints: Bool = true, condition: ((XY<T>?) -> Bool)? = nil) -> [Point] {
    let (circular0, circular1) = Canvas.sorted(unsortedCircular0, unsortedCircular1)
    return intersections(.twoCirculars(circular0, circular1), style: style, info: info, includeExistingPoints: includeExistingPoints, condition: condition)
  }
}
