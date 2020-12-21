import Numerics

public extension Canvas {
  final class Scalar: UnstyledFigureProtocol {
    let storage: FigureProtocolStorage<Geometry.Scalar<T>, ScalarStyle, FigureMeta>
    
    init(storage: FigureProtocolStorage<Geometry.Scalar<T>, ScalarStyle, FigureMeta>) {
      self.storage = storage
    }
    
    public var key: ObjectIdentifier { storage.shape.key }
    
    public typealias Value = T
    
    public var value: Value? { shape.value?.value }
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
    let scalar = Scalar(shape, style: .init(), meta: .init(), canvas: self)
    add(scalar)
    return scalar
  }
}

