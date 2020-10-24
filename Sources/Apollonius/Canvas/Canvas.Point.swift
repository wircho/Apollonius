import Numerics

public extension Canvas {
  struct PointStyle {
    public init() {}
  }
  
  final class Point {
    public let figure: Geometry.Point<T>
    public var style: PointStyle
    
    internal init(_ figure: Geometry.Point<T>, style: PointStyle) {
      self.figure = figure
      self.style = style
    }
  }
}

extension Canvas.Point: Shape {}

public extension Canvas {
  func point(at xy: XY<T>, style: PointStyle = PointStyle()) -> (Point, Geometry.Cursor<XY<T>>) {
    let cursor = Geometry.Cursor(xy)
    return (.init(.init(.free(cursor: cursor)), style: style), cursor)
  }
}
