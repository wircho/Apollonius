import Numerics

public extension Geometry {
  
  final class Point<T: Real & Codable> {
    public let index = Counter.shapes.newIndex()
    public var value: XY<T>? = nil
    public let parameters: PointParameters<T>
    public var children: Set<UnownedShape<T>> = []
    public var parents: Set<UnownedShape<T>> = []
    public var knownCurves: Set<UnownedCurve<T>> = []
    
    public init(_ parameters: PointParameters<T>) {
      self.parameters = parameters
      self.update()
      switch parameters {
      case .fixed, .free: break
      case let ._onStraightAbsolute(straight, _):
        makeChildOf(straight)
        layOn(straight)
      case let ._onStraightNormalized(straight,  _):
        makeChildOf(straight)
        layOn(straight)
      case let ._onCircular(circular, _):
        makeChildOf(circular)
        layOn(circular)
      case let ._twoStraightsIntersection(straight0, straight1):
        makeChildOf(straight0, straight1)
        layOn(straight0, straight1)
      case let ._intersection(intersection, _):
        makeChildOf(intersection)
        switch intersection.inner.object.parameters {
        case let ._straightCircular(straight, circular): layOn(straight, circular)
        case let ._twoCirculars(circular0, circular1): layOn(circular0, circular1)
        }
      case let ._oppositeIntersection(intersection, oppositePoint):
        makeChildOf(intersection, oppositePoint)
        switch intersection.inner.object.parameters {
        case let ._straightCircular(straight, circular): layOn(straight, circular)
        case let ._twoCirculars(circular0, circular1): layOn(circular0, circular1)
        }
      case let ._circumcenter(point0, point1, point2):
        makeChildOf(point0, point1, point2)
      }
    }
    
    deinit {
      clearAllParenting()
      clearAllCurves()
    }
  }
}
