import Numerics

public protocol CanvasMetaProtocol {
  associatedtype Info: FigureInfo
  associatedtype PointStyle: FigureStyle
  associatedtype StraightStyle: FigureStyle
  associatedtype CircularStyle: FigureStyle
  associatedtype ScalarStyle: FigureStyle
  associatedtype IntersectionStyle: FigureStyle
}

public protocol FigureProtocol {
  associatedtype F: Shape
  associatedtype Style: FigureStyle
  associatedtype Info: FigureInfo
  var shape: F { get }
  init(_ shape: F, style: Style, info: Info)
}

public protocol FigureInfo {
  init()
}

public protocol FigureStyle {
  init()
}

public final class Canvas<T: Real, G: Real, Meta: CanvasMetaProtocol> {
  public typealias Info = Meta.Info
  public typealias PointStyle = Meta.PointStyle
  public typealias StraightStyle = Meta.StraightStyle
  public typealias CircularStyle = Meta.CircularStyle
  public typealias ScalarStyle = Meta.ScalarStyle
  public typealias IntersectionStyle = Meta.IntersectionStyle
  
  var items: SortedDictionary<ObjectIdentifier, Item> = [:]
  var pointHandles: Dictionary<ObjectIdentifier, PointHandle> = [:]
}

public extension Canvas {
  final class Figure<F: Shape, Style: FigureStyle>: FigureProtocol where F.T == T {
    public let shape: F
    public var style: Style
    public var info: Info
    
    public init(_ shape: F, style: Style = .init(), info: Info = .init()) {
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
}

extension Shape {
  var key: ObjectIdentifier { return .init(self) }
}

extension UnownedShapeConvertibleInternal {
  var key: ObjectIdentifier { return .init(inner.object) }
}
