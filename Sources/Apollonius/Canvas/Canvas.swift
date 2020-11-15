import Numerics

public protocol CanvasMetaProtocol {
  associatedtype Info: FigureInfo
  associatedtype PointStyle: FigureStyle
  associatedtype StraightStyle: FigureStyle
  associatedtype CircularStyle: FigureStyle
}

public protocol FigureProtocol {
  associatedtype S: Shape
  associatedtype Style: FigureStyle
  associatedtype Info: FigureInfo
  var shape: S { get }
  init(_ shape: S, style: Style, info: Info)
}

public protocol FigureInfo: Codable {
  init()
}

public protocol FigureStyle: Codable {
  init()
}

public struct EmptyScalarStyle: FigureStyle {
  public init() {}
}

public struct EmptyIntersectionStyle: FigureStyle {
  public init() {}
}

public final class Canvas<T: Real & Codable, Meta: CanvasMetaProtocol> {
  public typealias Info = Meta.Info
  public typealias PointStyle = Meta.PointStyle
  public typealias StraightStyle = Meta.StraightStyle
  public typealias CircularStyle = Meta.CircularStyle
  public typealias ScalarStyle = EmptyScalarStyle
  public typealias IntersectionStyle = EmptyIntersectionStyle
  
  public let undoContext = UndoContext()
  var items: SortedDictionary<ObjectIdentifier, Item> = [:]
  var pointHandles: Dictionary<ObjectIdentifier, PointHandle> = [:]
}

public extension Canvas {
  func update() {
    for key in items.keys {
      items[key]?.update()
    }
  }
  
  func update(keys: Set<ObjectIdentifier>) {
    for key in items.keys {
      guard keys.contains(key) else { continue }
      items[key]?.update()
    }
  }
  
  func update(from key: ObjectIdentifier) {
    update(keys: gatherKeys(from: key, includeUpstreamIntersections: false))
  }
}

public extension Canvas {
  final class Figure<S: Shape, Style: FigureStyle>: FigureProtocol where S.T == T {
    public let shape: S
    public var style: Style
    public var info: Info
    
    public init(_ shape: S, style: Style = .init(), info: Info = .init()) {
      self.shape = shape
      self.style = style
      self.info = info
    }
  }
}

public extension Canvas {
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
  
  init?<Figure: FigureProtocol>(_ figure: Figure) {
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

extension Shape {
  var key: ObjectIdentifier { return .init(self) }
}

extension UnownedShapeConvertibleInternal {
  var key: ObjectIdentifier { return .init(inner.object) }
}
