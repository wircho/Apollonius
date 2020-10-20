import Numerics

public extension Geometry {
  enum ScalarParameters<T: Real> {
    case _length(segment: UnownedStraight<T>)
    
    public static func length(segment: UnownedStraight<T>) -> ScalarParameters<T> {
      guard segment.inner.object.parameters.kind == .segment else { fatalError("Length of Line or Ray is unsupported.") }
      return ._length(segment: segment)
    }
  }
  
  final class Scalar<T: Real> {
    public var value: Length<T>? = nil
    public let parameters: ScalarParameters<T>
    public var children: [UnownedFigure<T>] = []
    
    public init(_ parameters: ScalarParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let ._length(segment):
        // Parenting
        segment.asUnownedFigure.append(child: .init(self))
      }
    }
  }
}

extension Geometry.Scalar: Figure {
  public func newValue() -> Length<T>? {
    switch parameters {
    case let ._length(segment): return segment.inner.object.vector?.norm()
    }
  }
}

public struct UnownedScalar<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Scalar<T>>
  public let asUnownedFigure: UnownedFigure<T>
  
  init(_ scalar: Geometry.Scalar<T>) {
    inner = .init(scalar)
    asUnownedFigure = .init(scalar)
  }
}
