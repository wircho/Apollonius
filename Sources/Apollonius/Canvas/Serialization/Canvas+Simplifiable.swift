import Foundation
import Numerics

infix operator >>

private func fatal<T>() -> T {
  fatalError("Unsupported.")
}

struct Alias<S: GeometricShape>: Codable {
  let value: String
  
  init(_ value: String) { self.value = value }
  
  func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
  
  init(from decoder: Decoder) throws {
    try self.init(.init(from: decoder))
  }
}

extension ObjectIdentifier {
  var alias: String { return String(UInt(bitPattern: self)) }
}

extension GeometricShape {
  var alias: Alias<Self> { return .init(key.alias) }
}

extension UnownedPoint {
  var alias: Alias<Geometry.Point<T>> { return .init(key.alias) }
}

extension UnownedStraight {
  var alias: Alias<Geometry.Straight<T>> { return .init(key.alias) }
}

extension UnownedCircular {
  var alias: Alias<Geometry.Circular<T>> { return .init(key.alias) }
}

extension UnownedIntersection {
  var alias: Alias<Geometry.Intersection<T>> { return .init(key.alias) }
}

extension UnownedScalar {
  var alias: Alias<Geometry.Scalar<T>> { return .init(key.alias) }
}

final class CanvasContext<T: Real & Codable, Specifier: CanvasSpecifierProtocol>: SimplifiableContext {
  var aliasDictionary: [String: AnyUnowned] = [:]
  weak var canvas: Canvas<T, Specifier>? = nil
  
  init() {}
  
  func add<S: GeometricShape>(alias: String, shape: S) {
    aliasDictionary[alias] = AnyUnowned(shape)
  }
  
  func unsafe<S: GeometricShape>(_ alias: Alias<S>) -> S { return aliasDictionary[alias.value]!.object as! S }
  
}

final class AnyCanvasContext<T: Real & Codable>: SimplifiableContext {
  let originalContext: AnyObject
  let addMethod: (String, AnyUnowned) -> Void
  let unsafeMethod: (String) -> AnyUnowned
  
  func add<S: GeometricShape>(alias: String, shape: S) { addMethod(alias, .init(shape)) }
  
  func unsafe<S: GeometricShape>(_ alias: Alias<S>) -> S { unsafeMethod(alias.value).object as! S }
  
  
  init<Specifier: CanvasSpecifierProtocol>(originalContext: CanvasContext<T, Specifier>) {
    self.originalContext = originalContext
    addMethod = { (alias, u) in originalContext.aliasDictionary[alias] = u }
    unsafeMethod = { alias in originalContext.aliasDictionary[alias]! }
  }
  
  convenience init() {
    self.init(originalContext: CanvasContext<T, DefaultCanvasSpecifier>())
  }
  
  static func >>(context: AnyCanvasContext, alias: Alias<Geometry.Point<T>>) -> UnownedPoint<T>  {
    return .init(context.unsafe(alias))
  }
  
  static func >>(context: AnyCanvasContext, alias: Alias<Geometry.Straight<T>>) -> UnownedStraight<T>  {
    return .init(context.unsafe(alias))
  }
  
  static func >>(context: AnyCanvasContext, alias: Alias<Geometry.Circular<T>>) -> UnownedCircular<T>  {
    return .init(context.unsafe(alias))
  }
  
  static func >>(context: AnyCanvasContext, alias: Alias<Geometry.Intersection<T>>) -> UnownedIntersection<T>  {
    return .init(context.unsafe(alias))
  }
  
  static func >>(context: AnyCanvasContext, alias: Alias<Geometry.Scalar<T>>) -> UnownedScalar<T>  {
    return .init(context.unsafe(alias))
  }
}

extension Canvas: Simplifiable {
  typealias Context = CanvasContext<T, Specifier>
  
  struct Simplified: Codable {
    struct Element: Codable {
      let alias: String
      let item: Item.Simplified
    }
    
    let allowsUndo: Bool
    let elements: [Element]
  }
  
  func simplified() -> Simplified {
    return .init(allowsUndo: undoManager != nil, elements: items.keys.map {
      key in
      return .init(alias: key.alias, item: items.unorderedDictionary[key]!.simplified())
    })
  }
  
  private static func add<F: FigureProtocolInternal>(alias: String, figure: F, item: Canvas.Item, context: CanvasContext<T, Specifier>, canvas: Canvas) {
    context.add(alias: alias, shape: figure.shape)
    canvas.items.unsafelyAppend(key: figure.shape.key, value: item)
  }
  
  static func from(simplified: Simplified, context: CanvasContext<T, Specifier>) -> Canvas {
    let canvas = Canvas(.generic, allowsUndo: simplified.allowsUndo)
    context.canvas = canvas
    for element in simplified.elements {
      let item = Canvas.Item.from(simplified: element.item, context: context)
      switch item {
      case let .point(figure):
        add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
        switch figure.shape.parameters {
        case let ._onCircular(circular, cursor): canvas.pointHandles[figure.shape.key] = .init(point: figure, cursor: cursor, canvas: canvas) { circular.inner.object.cursorValue(near: $0) ?? .init(value: 0) }
        case let ._onStraightAbsolute(straight, cursor): canvas.pointHandles[figure.shape.key] = .init(point: figure, cursor: cursor, canvas: canvas) { straight.inner.object.absoluteCursorValue(near: $0) ?? .init(value: 0) }
        case let ._onStraightNormalized(straight, cursor): canvas.pointHandles[figure.shape.key] = .init(point: figure, cursor: cursor, canvas: canvas) { straight.inner.object.normalizedCursorValue(near: $0) ?? 1/2 }
        case let .free(cursor): canvas.pointHandles[figure.shape.key] = .init(point: figure, cursor: cursor, canvas: canvas) { $0 }
        case ._circumcenter, ._intersection, ._oppositeIntersection, ._twoStraightsIntersection, .fixed: break
        }
      case let .line(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .ray(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .segment(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .circle(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .arc(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .intersection(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      case let .scalar(figure): add(alias: element.alias, figure: figure, item: item, context: context, canvas: canvas)
      }
    }
    return canvas
  }
}

extension Canvas.Item: Simplifiable {
  typealias Context = CanvasContext<T, Specifier>
  
  struct Simplified: Codable {
    let point: Canvas.Point.Simplified?
    let line: Canvas.Line.Simplified?
    let ray: Canvas.Ray.Simplified?
    let segment: Canvas.Segment.Simplified?
    let circle: Canvas.Circle.Simplified?
    let arc: Canvas.Arc.Simplified?
    let intersection: Canvas.Intersection.Simplified?
    let scalar: Canvas.Scalar.Simplified?
    
    init(point: Canvas.Point.Simplified? = nil, line: Canvas.Line.Simplified? = nil, ray: Canvas.Ray.Simplified? = nil, segment: Canvas.Segment.Simplified? = nil, circle: Canvas.Circle.Simplified? = nil, arc: Canvas.Arc.Simplified? = nil, intersection: Canvas.Intersection.Simplified? = nil, scalar: Canvas.Scalar.Simplified? = nil) {
      self.point = point
      self.line = line
      self.ray = ray
      self.segment = segment
      self.circle = circle
      self.arc = arc
      self.intersection = intersection
      self.scalar = scalar
    }
  }
  
  func simplified() -> Simplified {
    switch self {
    case let .point(figure): return .init(point: figure.simplified())
    case let .line(figure): return .init(line: figure.simplified())
    case let .ray(figure): return .init(ray: figure.simplified())
    case let .segment(figure): return .init(segment: figure.simplified())
    case let .circle(figure): return .init(circle: figure.simplified())
    case let .arc(figure): return .init(arc: figure.simplified())
    case let .intersection(figure): return .init(intersection: figure.simplified())
    case let .scalar(figure): return .init(scalar: figure.simplified())
    }
  }
  
  static func from(simplified: Simplified, context: CanvasContext<T, Specifier>) -> Canvas.Item {
    if let it = simplified.point {
      return .point(.from(simplified: it, context: context))
    } else if let it = simplified.line {
      return .line(.from(simplified: it, context: context))
    } else if let it = simplified.ray {
      return .ray(.from(simplified: it, context: context))
    } else if let it = simplified.segment {
      return .segment(.from(simplified: it, context: context))
    } else if let it = simplified.circle {
      return .circle(.from(simplified: it, context: context))
    } else if let it = simplified.arc {
      return .arc(.from(simplified: it, context: context))
    } else if let it = simplified.intersection {
      return .intersection(.from(simplified: it, context: context))
    } else if let it = simplified.scalar {
      return .scalar(.from(simplified: it, context: context))
    } else {
      return fatal()
    }
  }
}

struct SimplifiedFigure<F: FigureProtocolInternal> {
  let shape: F.S.Simplified
  let style: F.Style
  let meta: F.Meta
}

extension FigureProtocolInternal {
  func simplified() -> SimplifiedFigure<Self> {
    return .init(shape: shape.simplified(), style: style, meta: meta)
  }
  
  static func from(simplified: SimplifiedFigure<Self>, context: CanvasContext<S.T, Specifier>) -> Self {
    let anyCanvasContext = AnyCanvasContext(originalContext: context)
    return .init(.from(simplified: simplified.shape, context: anyCanvasContext), style: simplified.style, meta: simplified.meta, canvas: context.canvas)
  }
}

extension SimplifiedFigure: Codable where F.S.Simplified: Codable {}

extension Geometry.Intersection: Simplifiable {
  typealias Context = AnyCanvasContext<T>
  
  struct Simplified: Codable {
    struct StraightCircular: Codable {
      let straight: Alias<Geometry.Straight<T>>
      let circular: Alias<Geometry.Circular<T>>
    }
    
    struct TwoCirculars: Codable {
      let circular0, circular1: Alias<Geometry.Circular<T>>
    }
    
    let straightCircular: StraightCircular?
    let twoCirculars: TwoCirculars?
    
    init(straightCircular: StraightCircular? = nil, twoCirculars: TwoCirculars? = nil) {
      self.straightCircular = straightCircular
      self.twoCirculars = twoCirculars
    }
  }
  
  func simplified() -> Simplified {
    switch parameters {
    case let ._straightCircular(straight, circular):
      return .init(straightCircular: .init(straight: straight.alias, circular: circular.alias))
    case let ._twoCirculars(circular0, circular1):
      return .init(twoCirculars: .init(circular0: circular0.alias, circular1: circular1.alias))
    }
  }
  
  static func from(simplified: Simplified, context: AnyCanvasContext<T>) -> Geometry.Intersection<T> {
    if let it = simplified.straightCircular {
      return .init(._straightCircular(context >> it.straight, context >> it.circular))
    } else if let it = simplified.twoCirculars {
      return .init(._twoCirculars(context >> it.circular0, context >> it.circular1))
    } else {
      return fatal()
    }
  }
}

extension Geometry.Scalar: Simplifiable {
  typealias Context = AnyCanvasContext<T>
  
  struct Simplified: Codable {
    struct Distance: Codable {
      let point0, point1: Alias<Geometry.Point<T>>
    }
    
    let distance: Distance?
    
    init(distance: Distance? = nil) {
      self.distance = distance
    }
  }
  
  func simplified() -> Simplified {
    switch parameters {
    case let ._distance(point0, point1):
      return .init(distance: .init(point0: point0.alias, point1: point1.alias))
    }
  }
  
  static func from(simplified: Simplified, context: AnyCanvasContext<T>) -> Geometry.Scalar<T> {
    if let it = simplified.distance {
      return .init(._distance(context >> it.point0, context >> it.point1))
    } else {
      return fatal()
    }
  }
}

extension Geometry.Circular: Simplifiable {
  typealias Context = AnyCanvasContext<T>
  
  struct Simplified: Codable {
    struct Arc: Codable {
      let point0, point1, point2: Alias<Geometry.Point<T>>
    }
    
    struct Between: Codable {
      let center, tip: Alias<Geometry.Point<T>>
    }
    
    struct Circumcircle: Codable {
      let point0, point1, point2: Alias<Geometry.Point<T>>
    }
    
    struct With: Codable {
      let center: Alias<Geometry.Point<T>>
      let radius: Alias<Geometry.Scalar<T>>
    }
    
    let arc: Arc?
    let between: Between?
    let circumcircle: Circumcircle?
    let with: With?
    
    init(arc: Arc? = nil, between: Between? = nil, circumcircle: Circumcircle? = nil, with: With? = nil) {
      self.arc = arc
      self.between = between
      self.circumcircle = circumcircle
      self.with = with
    }
  }
  
  func simplified() -> Simplified {
    switch parameters {
    case let ._arc(point0, point1, point2):
      return .init(arc: .init(point0: point0.alias, point1: point1.alias, point2: point2.alias))
    case let ._between(center, tip):
      return .init(between: .init(center: center.alias, tip: tip.alias))
    case let ._circumcircle(point0, point1, point2):
      return .init(circumcircle: .init(point0: point0.alias, point1: point1.alias, point2: point2.alias))
    case let ._with(center, radius):
      return .init(with: .init(center: center.alias, radius: radius.alias))
    }
  }
  
  static func from(simplified: Simplified, context: AnyCanvasContext<T>) -> Geometry.Circular<T> {
    if let it = simplified.arc {
      return .init(._arc(context >> it.point0, context >> it.point1, context >> it.point2))
    } else if let it = simplified.between {
      return .init(._between(center: context >> it.center, tip: context >> it.tip))
    } else if let it = simplified.circumcircle {
      return .init(._circumcircle(context >> it.point0, context >> it.point1, context >> it.point2))
    } else if let it = simplified.with {
      return .init(._with(center: context >> it.center, radius: context >> it.radius))
    } else {
      fatalError("Unsupported.")
    }
  }
}

extension Geometry.Straight: Simplifiable {
  typealias Context = AnyCanvasContext<T>
  
  struct Simplified: Codable {
    struct Between: Codable {
      let origin, tip: Alias<Geometry.Point<T>>
    }
    
    struct Directed: Codable {
      let origin: Alias<Geometry.Point<T>>
      let other: Alias<Geometry.Straight<T>>
      let direction: Geometry.StraightDirection
    }
    
    let kind: Geometry.StraightKind
    let between: Between?
    let directed: Directed?
    
    init(kind: Geometry.StraightKind, between: Between? = nil, directed: Directed? = nil) {
      self.kind = kind
      self.between = between
      self.directed = directed
    }
  }
  
  func simplified() -> Simplified {
    switch parameters.definition {
    case let ._between(origin, tip):
      return .init(kind: parameters.kind, between: .init(origin: origin.alias, tip: tip.alias))
    case let ._directed(direction, origin, other):
      return .init(kind: parameters.kind, directed: .init(origin: origin.alias, other: other.alias, direction: direction))
    }
  }
  
  static func from(simplified: Simplified, context: AnyCanvasContext<T>) -> Geometry.Straight<T> {
    if let it = simplified.between {
      return .init(.init(simplified.kind, ._between(origin: context >> it.origin, tip: context >> it.tip)))
    } else if let it = simplified.directed {
      return .init(.init(simplified.kind, ._directed(direction: it.direction, origin: context >> it.origin, other: context >> it.other)))
    } else {
      return fatal()
    }
  }
}

extension Geometry.Point: Simplifiable {
  typealias Context = AnyCanvasContext<T>
  
  struct Simplified: Codable {
    struct Circumcenter: Codable {
      let point0, point1, point2: Alias<Geometry.Point<T>>
    }
    
    struct Intersection: Codable {
      let intersection: Alias<Geometry.Intersection<T>>
      let index: Geometry.IntersectionIndex
    }
    
    struct OnCircular: Codable {
      let circular: Alias<Geometry.Circular<T>>
      let cursorValue: T
    }
    
    struct OnStraight: Codable {
      let straight: Alias<Geometry.Straight<T>>
      let cursorValue: T
    }
    
    struct OppositeIntersection: Codable {
      let intersection: Alias<Geometry.Intersection<T>>
      let oppositePoint: Alias<Geometry.Point<T>>
    }
    
    struct TwoStraightsIntersection: Codable {
      let straight0, straight1: Alias<Geometry.Straight<T>>
    }
    
    struct Position: Codable {
      let x, y: T
    }
    
    let circumcenter: Circumcenter?
    let intersection: Intersection?
    let onCircular: OnCircular?
    let onStraightAbsolute: OnStraight?
    let onStraightNormalized: OnStraight?
    let oppositeIntersection: OppositeIntersection?
    let twoStraightsIntersection: TwoStraightsIntersection?
    let fixed: Position?
    let free: Position?
    
    init(circumcenter: Circumcenter? = nil, intersection: Intersection? = nil, onCircular: OnCircular? = nil, onStraightAbsolute: OnStraight? = nil, onStraightNormalized: OnStraight? = nil, oppositeIntersection: OppositeIntersection? = nil, twoStraightsIntersection: TwoStraightsIntersection? = nil, fixed: Position? = nil, free: Position? = nil) {
      self.circumcenter = circumcenter
      self.intersection = intersection
      self.onCircular = onCircular
      self.onStraightAbsolute = onStraightAbsolute
      self.onStraightNormalized = onStraightNormalized
      self.oppositeIntersection = oppositeIntersection
      self.twoStraightsIntersection = twoStraightsIntersection
      self.fixed = fixed
      self.free = free
    }
  }
  
  func simplified() -> Simplified {
    switch parameters {
    case let ._circumcenter(point0, point1, point2):
      return .init(circumcenter: .init(point0: point0.alias, point1: point1.alias, point2: point2.alias))
    case let ._intersection(intersection, index):
      return .init(intersection: .init(intersection: intersection.alias, index: index))
    case let ._onCircular(circular, cursor):
      return .init(onCircular: .init(circular: circular.alias, cursorValue: cursor.value.value))
    case let ._onStraightAbsolute(straight, cursor):
      return .init(onStraightAbsolute: .init(straight: straight.alias, cursorValue: cursor.value.value))
    case let ._onStraightNormalized(straight, cursor):
      return .init(onStraightNormalized: .init(straight: straight.alias, cursorValue: cursor.value))
    case let ._oppositeIntersection(intersection, oppositePoint):
      return .init(oppositeIntersection: .init(intersection: intersection.alias, oppositePoint: oppositePoint.alias))
    case let ._twoStraightsIntersection(straight0, straight1):
      return .init(twoStraightsIntersection: .init(straight0: straight0.alias, straight1: straight1.alias))
    case let .fixed(position):
      return .init(fixed: .init(x: position.x.value, y: position.y.value))
    case let .free(cursor):
      return .init(free: .init(x: cursor.value.x.value, y: cursor.value.y.value))
    }
  }
  
  static func from(simplified: Simplified, context: AnyCanvasContext<T>) -> Geometry.Point<T> {
    if let it = simplified.circumcenter {
      return .init(._circumcenter(context >> it.point0, context >> it.point1, context >> it.point2))
    } else if let it = simplified.intersection {
      return .init(._intersection(context >> it.intersection, index: it.index))
    } else if let it = simplified.onCircular {
      let cursor = Geometry.Cursor(SimpleAngle(value: it.cursorValue))
      return .init(._onCircular(context >> it.circular, cursor: cursor))
    } else if let it = simplified.onStraightAbsolute {
      let cursor = Geometry.Cursor(Length(value: it.cursorValue))
      return .init(._onStraightAbsolute(context >> it.straight, cursor: cursor))
    } else if let it = simplified.onStraightNormalized {
      let cursor = Geometry.Cursor(it.cursorValue)
      return .init(._onStraightNormalized(context >> it.straight, cursor: cursor))
    } else if let it = simplified.oppositeIntersection {
      return .init(._oppositeIntersection(context >> it.intersection, oppositePoint: context >> it.oppositePoint))
    } else {
      return fatal()
    }
  }
}
