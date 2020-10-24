import Numerics

public extension Geometry {
  enum StraightKind {
    case line, segment, ray
  }
  
  enum StraightDirection {
    case parallel, perpendicular
  }
  
  enum StraightDefinition<T: Real> {
    case _between(origin: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _directed(direction: StraightDirection, origin: UnownedPoint<T>, other: UnownedStraight<T>)
    
    public static func between(origin: Point<T>, tip: Point<T>) -> StraightDefinition {
      return ._between(origin: .init(origin), tip: .init(tip))
    }
    
    public static func directed(direction: StraightDirection, origin: Point<T>, other: Straight<T>) -> StraightDefinition {
      return ._directed(direction: direction, origin: .init(origin), other: .init(other))
    }
  }
  
  struct StraightParameters<T: Real> {
    let kind: StraightKind
    let definition: StraightDefinition<T>
    
    public init(_ kind: StraightKind, _ definition: StraightDefinition<T>) {
      self.kind = kind
      self.definition = definition
    }
  }
  
  final class Straight<T: Real> {
    public struct Value {
      public let origin: XY<T>
      public let tip: XY<T>
    }
    
    public var value: Value? = nil
    public let parameters: StraightParameters<T>
    public var children: [UnownedFigure<T>] = []
    public var knownPoints: [UnownedPoint<T>] = []
    
    public init(_ parameters: StraightParameters<T>) {
      self.parameters = parameters
      switch parameters.definition {
      case let ._between(origin, tip):
        // Parenting
        origin.inner.object.children.append(.init(self))
        tip.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(contentsOf: [origin, tip])
        // Known Curves
        origin.inner.object.knwonCurves.append(.init(self))
      case let ._directed(_, origin, other):
        // Parenting
        origin.inner.object.children.append(.init(self))
        other.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(origin)
        // Known Curves
        origin.inner.object.knwonCurves.append(.init(self))
      }
      update()
    }
  }
}

extension Geometry.Straight: Curve {
  public func newValue() -> Geometry.Straight<T>.Value? {
    switch parameters.definition {
    case let ._between(origin, tip):
      guard let xy0 = origin.inner.object.value, let xy1 = tip.inner.object.value else { return nil }
      return .init(origin: xy0, tip: xy1)
    case let ._directed(direction, origin, other):
      guard let xy0 = origin.inner.object.value, let vector = other.inner.object.vector else { return nil }
      switch direction {
      case .parallel: return .init(origin: xy0, tip: xy0 + vector)
      case .perpendicular: return .init(origin: xy0, tip: xy0 + vector.rotated90Degrees)
      }
    }
  }
}

public extension Geometry.Straight.Value {
  var vector: DXY<T> {
    return tip - origin
  }
  
  var angle: Angle<T>? {
    return vector.angle
  }
  
  var length: Length<T> {
    return vector.norm()
  }
}

public extension Geometry.Straight {
  var vector: DXY<T>? {
    return value?.vector
  }
  
  func contains(normalizedValue: T) -> Bool? {
    guard value != nil else { return nil }
    switch parameters.kind {
    case .line: return true
    case .ray: return normalizedValue >= 0
    case .segment: return normalizedValue >= 0 && normalizedValue <= 1
    }
  }
  
  func contains(absoluteValue: Length<T>) -> Bool? {
    guard let length = value?.length else { return nil }
    switch parameters.kind {
    case .line: return true
    case .ray: return absoluteValue >= 0
    case .segment: return absoluteValue >= 0 && absoluteValue <= length
    }
  }
}

public extension Geometry.Straight.Value {
  fileprivate func unrestrictedAbsoluteCursorValueAndNorm(near xy: XY<T>) -> (Length<T>, Length<T>)? {
    let vector = self.vector
    let xyVector = xy - origin
    let norm = vector.norm()
    return ((vector • xyVector) / norm).map{ ($0, norm) }
  }
}

public extension Geometry.Straight {
  func normalizedCursorValue(near xy: XY<T>) -> T? {
    guard let (unrestricted, norm) = value?.unrestrictedAbsoluteCursorValueAndNorm(near: xy) else { return nil }
    switch parameters.kind {
    case .line: return unrestricted / norm
    case .ray: return (unrestricted < 0) ? 0 : unrestricted / norm
    case .segment: return (unrestricted < 0) ? 0 : (unrestricted > norm) ? 1 : unrestricted / norm
    }
  }
  
  func absoluteCursorValue(near xy: XY<T>) -> Length<T>? {
    guard let (unrestricted, norm) = value?.unrestrictedAbsoluteCursorValueAndNorm(near: xy) else { return nil }
    switch parameters.kind {
    case .line: return unrestricted
    case .ray: return (unrestricted < 0) ? .init(value: 0) : unrestricted
    case .segment: return (unrestricted < 0) ? .init(value: 0) : (unrestricted > norm) ? norm : unrestricted
    }
  }
}

public struct UnownedStraight<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Straight<T>>
  public let asUnownedCurve: UnownedCurve<T>
  // Computed
  public var asUnownedFigure: UnownedFigure<T> { return asUnownedCurve.asUnownedFigure }
  
  init(_ straight: Geometry.Straight<T>) {
    inner = .init(straight)
    asUnownedCurve = .init(straight)
  }
}
