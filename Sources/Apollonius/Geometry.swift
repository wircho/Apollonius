import Numerics

// Geometry

public enum Geometry {}

// Figure


public protocol Figure: AnyObject {
  associatedtype T: Real
  associatedtype Parameters
  associatedtype Value
  var children: [UnownedFigure<T>] { get set }
  var parameters: Parameters { get }
  var value: Value? { get set }
  init(_ parameters: Parameters)
  func newValue() -> Value?
}

public extension Figure {
  func update() { value = newValue() }
}

// UnownedFigure

import Numerics

public protocol UnownedFigureConvertible {
  associatedtype T: Real
  var asUnownedFigure: UnownedFigure<T> { get }
}

protocol UnownedFigureConvertibleInternal: UnownedFigureConvertible {
  associatedtype ObjectType: AnyObject
  var inner: Unowned<ObjectType> { get }
}

public struct UnownedFigure<T: Real> {
  let _children: () -> [UnownedFigure<T>]
  let _appendChild: (UnownedFigure<T>) -> Void
  let _update: () -> Void
  let inner: Unowned<AnyObject>
  
  public var children: [UnownedFigure]? { return _children() }
  public func append(child: UnownedFigure<T>) { _appendChild(child) }
  public func update() { _update() }
  
  init<F: Figure>(_ figure: F) where F.T == T {
    self.inner = .init(figure)
    self._children = { [weak figure] in figure!.children }
    self._appendChild = { [weak figure] child in figure!.children.append(child) }
    self._update = { [weak figure] in figure!.update() }
  }
}

extension UnownedFigure: UnownedFigureConvertibleInternal {
  public var asUnownedFigure: UnownedFigure<T> { return self }
}

func ==<F0: UnownedFigureConvertible, F1: UnownedFigureConvertible>(lhs: F0, rhs: F1) -> Bool {
  return lhs.asUnownedFigure.inner.object === rhs.asUnownedFigure.inner.object
}

func ==<F0: Figure, F1: UnownedFigureConvertible>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
  return lhs === rhs.asUnownedFigure.inner.object
}

func ==<F0: UnownedFigureConvertible, F1: Figure>(lhs: F0, rhs: F1) -> Bool where F0.T == F1.T {
  return lhs.asUnownedFigure.inner.object === rhs
}

// Scalar

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

// Cursor

public extension Geometry {
  final class Cursor<Value> {
    public var value: Value
    public init(_ value: Value) { self.value = value }
  }
}

// Intersection (An intermediate step for some intersection points)

public extension Geometry {
  enum IntersectionParameters<T: Real> {
    case straightCircular(UnownedStraight<T>, UnownedCircular<T>)
    case twoCirculars(UnownedCircular<T>, UnownedCircular<T>)
  }
  
  final class Intersection<T: Real> {
    public struct Value {
      public let first: XY<T>?
      public let second: XY<T>?
    }
    
    public var value: Value? = nil
    public let parameters: IntersectionParameters<T>
    public var children: [UnownedFigure<T>] = []
    
    public init(_ parameters: IntersectionParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let .straightCircular(straight, circular):
        // Parenting
        straight.inner.object.children.append(UnownedFigure(self))
        circular.inner.object.children.append(UnownedFigure(self))
      case let .twoCirculars(circular0, circular1):
        // Parenting
        circular0.inner.object.children.append(UnownedFigure(self))
        circular1.inner.object.children.append(UnownedFigure(self))
      }
    }
  }
}

extension Geometry.Intersection: Figure {
  public func newValue() -> Value? {
    switch parameters {
    case let .straightCircular(straight, circular):
      guard let straightValue = straight.inner.object.value, let circularValue = circular.inner.object.value else { return nil }
      let vector = straightValue.vector
      let origin = straightValue.origin
      let center = circularValue.center
      let radius = circularValue.radius
      let centerToOrigin = origin - center
      let a = vector.normSquared()
      let b = 2 * (vector • centerToOrigin)
      let c = centerToOrigin.normSquared() - radius.squared()
      let discriminant = b.squared() - 4 * (a * c)
      guard let discriminantSquareRoot = discriminant.squareRoot() else { return nil }
      let numerators = (-b + discriminantSquareRoot, -b - discriminantSquareRoot)
      let denominator = 2 * a
      let t = [numerators.0 / denominator, numerators.0 / denominator].map { (t: T?) -> T? in
        guard let t = t, straight.inner.object.contains(normalizedValue: t) == true else { return nil }
        return t
      }
      let xy = t.map { (t: T?) -> XY<T>? in
        guard let t = t else { return nil }
        let xy = origin + t * vector
        guard let angle = (xy - center).angle else { return nil }
        guard circular.inner.object.contains(angle: angle) == true else { return nil }
        return xy
      }
      return .init(first: xy[0], second: xy[1])
    case let .twoCirculars(circular0, circular1):
      guard let circularValue0 = circular0.inner.object.value, let circularValue1 = circular1.inner.object.value else { return nil }
      let center0 = circularValue0.center
      let radius0 = circularValue0.radius
      let center1 = circularValue1.center
      let radius1 = circularValue1.radius
      let vector = center1 - center0
      let d2 = vector.normSquared()
      let radiusSquared0 = radius0.squared()
      let radiusSquared1 = radius1.squared()
      let squaresSum = radiusSquared0 + radiusSquared1
      let squaresDifference = radiusSquared0 - radiusSquared1
      guard let a = squaresSum / d2, let b = squaresDifference / d2 else { return nil }
      let discriminant = (2 * a - b * b - 1).squareRoot() / 2
      guard discriminant.isFinite else { return nil }
      let vector90 = vector.rotated90Degreess()
      
    }
  }
}

// Point

public extension Geometry {
  enum IntersectionIndex {
    case first, second
  }
  
  enum PointParameters<T: Real> {
    case free(cursor: Cursor<XY<T>>)
    case _onStraightAbsolute(UnownedStraight<T>, cursor: Cursor<Length<T>>)
    case _onStraightNormalized(UnownedStraight<T>, cursor: Cursor<T>)
    case _onCircular(UnownedCircular<T>, cursor: Cursor<Angle<T>>)
    case _twoStraightsIntersection(UnownedStraight<T>, UnownedStraight<T>)
    case _straightCircularIntersection(UnownedStraight<T>, UnownedCircular<T>, index: IntersectionIndex)
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<T>) -> PointParameters<T> {
      return ._onStraightNormalized(.init(straight), cursor: cursor)
    }
    
    public static func on(_ straight: Straight<T>, cursor: Cursor<Length<T>>) -> PointParameters<T> {
      return ._onStraightAbsolute(.init(straight), cursor: cursor)
    }
    
    public static func on(_ circular: Circular<T>, cursor: Cursor<Angle<T>>) -> PointParameters<T> {
      return ._onCircular(.init(circular), cursor: cursor)
    }
  }
  
  final class Point<T: Real> {
    public var value: XY<T>? = nil
    public let parameters: PointParameters<T>
    public var children: [UnownedFigure<T>] = []
    public var knwonCurves: [UnownedCurve<T>] = []
    
    public init(_ parameters: PointParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case .free: break
      case let ._onStraightAbsolute(straight, _):
        // Parenting
        straight.inner.object.children.append(.init(self))
        // Known Points
        straight.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(straight.asUnownedCurve)
      case let ._onStraightNormalized(straight,  _):
        // Parenting
        straight.inner.object.children.append(.init(self))
        // Known Points
        straight.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(straight.asUnownedCurve)
      case let ._onCircular(circular,  _):
        // Parenting
        circular.inner.object.children.append(.init(self))
        // Known Points
        circular.inner.object.knownPoints.append(.init(self))
        // Known Curves
        self.knwonCurves.append(circular.asUnownedCurve)
      }
    }
  }
}

extension Geometry.Point: Figure {
  public func newValue() -> XY<T>? {
    switch parameters {
    case let .free(cursor):
      return cursor.value
    case let ._onStraightAbsolute(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value)
    case let ._onStraightNormalized(straight, cursor):
      guard let straightValue = straight.inner.object.value, let angle = straightValue.vector.angle else { return nil }
      return straightValue.origin + angle.dxy(at: cursor.value * straightValue.length)
    case let ._onCircular(circular, cursor):
      guard let circularValue = circular.inner.object.value else { return nil }
      return circularValue.center + cursor.value.dxy(at: circularValue.radius)
    }
  }
}

public struct UnownedPoint<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Point<T>>
  public let asUnownedFigure: UnownedFigure<T>
  
  init(_ point: Geometry.Point<T>) {
    inner = .init(point)
    asUnownedFigure = .init(point)
  }
}

// Curve

public protocol Curve: Figure {
  var knownPoints: [UnownedPoint<T>] { get set }
}

public struct UnownedCurve<T: Real>: UnownedFigureConvertibleInternal {
  public let asUnownedFigure: UnownedFigure<T>
  // Computed
  var inner: Unowned<AnyObject> { return asUnownedFigure.inner }
  
  init<C: Curve>(_ curve: C) where C.T == T {
    asUnownedFigure = .init(curve)
  }
}

// Straight

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

// Circular

public extension Geometry {
  enum CircularParameters<T: Real> {
    case _between(center: UnownedPoint<T>, tip: UnownedPoint<T>)
    case _with(center: UnownedPoint<T>, radius: UnownedScalar<T>)
    
    public static func between(center: Point<T>, tip: Point<T>) -> CircularParameters<T> {
      return ._between(center: .init(center), tip: .init(tip))
    }
    
    public static func with(center: Point<T>, radius: Scalar<T>) -> CircularParameters<T> {
      return ._with(center: .init(center), radius: .init(radius))
    }
  }
  
  final class Circular<T: Real> {
    public struct Value {
      public let center: XY<T>
      public let radius: Length<T>
      public let interval: AngleInterval<T>?
    }
    
    public var value: Value? = nil
    public let parameters: CircularParameters<T>
    public var children: [UnownedFigure<T>] = []
    public var knownPoints: [UnownedPoint<T>] = []
    
    public init(_ parameters: CircularParameters<T>) {
      self.parameters = parameters
      switch parameters {
      case let ._between(center, tip):
        // Parenting
        center.inner.object.children.append(.init(self))
        tip.inner.object.children.append(.init(self))
        // Known Points
        knownPoints.append(tip)
        // Known Curves
        tip.inner.object.knwonCurves.append(.init(self))
      case let ._with(center, radius):
        // Parenting
        center.inner.object.children.append(.init(self))
        radius.inner.object.children.append(.init(self))
      }
    }
  }
}

extension Geometry.Circular: Curve {
  public func newValue() -> Geometry.Circular<T>.Value? {
    switch parameters {
    case let ._between(center, tip):
      guard let center = center.inner.object.value, let tip = tip.inner.object.value else { return nil }
      return .init(center: center, radius: (tip - center).norm(), interval: nil)
    case let ._with(center, radius):
      guard let center = center.inner.object.value, let radius = radius.inner.object.value else { return nil }
      return .init(center: center, radius: radius, interval: nil)
    }
  }
}

public extension Geometry.Circular {
  func contains(angle: Angle<T>) -> Bool? {
    guard let value = self.value else { return nil }
    return value.interval?.contains(angle) ?? true
  }
}

public extension Geometry.Circular {
  func cursorValue(near xy: XY<T>) -> Angle<T>? {
    guard let center = value?.center else { return nil }
    return (xy - center).angle
  }
}

public struct UnownedCircular<T: Real>: UnownedFigureConvertibleInternal {
  let inner: Unowned<Geometry.Circular<T>>
  public let asUnownedCurve: UnownedCurve<T>
  // Computed
  public var asUnownedFigure: UnownedFigure<T> { return asUnownedCurve.asUnownedFigure }
  
  init(_ circular: Geometry.Circular<T>) {
    inner = .init(circular)
    asUnownedCurve = .init(circular)
  }
}


