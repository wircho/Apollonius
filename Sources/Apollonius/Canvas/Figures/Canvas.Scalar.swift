import Numerics

public extension Canvas {
  final class Scalar: FigureProtocolInternal {
    public typealias Value = T
    
    typealias Shape = Geometry.Scalar<T>
    public typealias Style = Canvas.ScalarStyle
    public typealias Meta = Canvas.FigureMeta
    
    let shape: Shape
    public var style: Style
    public var meta: Meta
    
    public var value: Value? {
      return shape.value?.value
    }
    
    init(_ shape: Shape, style: Style, meta: Meta) {
      self.shape = shape
      self.style = style
      self.meta = meta
    }
  }
}

public extension Canvas {
  func distance(_ unsortedPoint0: Point, _ unsortedPoint1: Point, style: ScalarStyle = .init(), meta: FigureMeta = .init()) -> Scalar {
    let (point0, point1) = Canvas.sorted(unsortedPoint0, unsortedPoint1)
    for child in commonChildren(point0, point1) {
      guard case let .scalar(scalar) = child else { continue }
      guard case let ._distance(otherPoint0, otherPoint1) = scalar.shape.parameters else { continue }
      guard otherPoint0 == point0.shape, otherPoint1 == point1.shape else { continue }
      return scalar
    }
    // Creating shape
    let shape = Geometry.Scalar.distance(point0.shape, point1.shape)
    let scalar = Scalar(shape, style: style, meta: meta)
    add(scalar)
    return scalar
  }
}

