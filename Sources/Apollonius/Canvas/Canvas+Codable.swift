//extension Canvas: CodableByProxy {
//  public struct Proxy: Codable {
//    let items: SortedDictionary<String, Item.Proxy>
//  }
//  
//  public convenience init(proxy: Proxy) throws {
//    var actualShapeKeys: [String: ShapeKey] = [:]
//    for proxyItemKey in proxy.items.keys {
//      let proxyItem = proxy.items.unsortedDictionary[proxyItemKey]!
//      switch proxyItem {
//        
//      }
//    }
//  }
//  
//  public func toProxy() throws -> Proxy {
//    
//  }
//}
//
//extension Canvas.Item: RepresentableToProxy {
//  public struct Proxy: Codable {
//    let point: Canvas.Point.Proxy?
//    let straight: Canvas.Straight.Proxy?
//    let circular: Canvas.Circular.Proxy?
//    let scalar: Canvas.Scalar.Proxy?
//    let intersection: Canvas.Intersection.Proxy?
//    
//    init(point: Canvas.Point.Proxy? = nil, straight: Canvas.Straight.Proxy? = nil, circular: Canvas.Circular.Proxy? = nil, scalar: Canvas.Scalar.Proxy? = nil, intersection: Canvas.Intersection.Proxy? = nil) {
//      self.point = point
//      self.straight = straight
//      self.circular = circular
//      self.scalar = scalar
//      self.intersection = intersection
//    }
//  }
//  
//  public func toProxy() throws -> Proxy {
//    switch self {
//    case let .point(figure): return try .init(point: figure.toProxy())
//    case let .straight(figure): return try .init(straight: figure.toProxy())
//    case let .circular(figure): return try .init(circular: figure.toProxy())
//    case let .scalar(figure): return try .init(scalar: figure.toProxy())
//    case let .intersection(figure): return try .init(intersection: figure.toProxy())
//    }
//  }
//}
//
//extension Canvas.Figure: RepresentableToProxy {
//  public struct Proxy: Codable {
//    let style: Style
//    let info: Info
//    let shape: S.Proxy
//  }
//  
//  public func toProxy() throws -> Proxy {
//    return try .init(style: style, info: info, shape: shape.toProxy())
//  }
//}
//
//extension Geometry.Point: RepresentableToProxy {
//  public struct Proxy: Codable {
//    typealias Circumcenter = [String]
//    
//    struct Intersection: Codable {
//      let intersection: String
//      let index: Geometry.IntersectionIndex
//    }
//    
//    struct OnCircular: Codable {
//      let circular: String
//      let cursorValue: T
//    }
//    
//    struct Fixed: Codable {
//      let x: T
//      let y: T
//    }
//    
//    struct OnStraightAbsolute: Codable {
//      let straight: String
//      let cursorValue: T
//    }
//    
//    struct OnStraightNormalized: Codable {
//      let straight: String
//      let cursorValue: T
//    }
//    
//    struct OppositeIntersection: Codable {
//      let intersection: String
//      let oppositePoint: String
//    }
//    
//    typealias TwoStraightsIntersection = [String]
//    
//    struct Free: Codable {
//      let x: T
//      let y: T
//    }
//    
//    let circumcenter: Circumcenter?
//    let intersection: Intersection?
//    let onCircular: OnCircular?
//    let fixed: Fixed?
//    let onStraightAbsolute: OnStraightAbsolute?
//    let onStraightNormalized: OnStraightNormalized?
//    let oppositeIntersection: OppositeIntersection?
//    let twoStraightsIntersection: TwoStraightsIntersection?
//    let free: Free?
//    
//    init(circumcenter: Circumcenter? = nil, intersection: Intersection? = nil, onCircular: OnCircular? = nil, fixed: Fixed? = nil, onStraightAbsolute: OnStraightAbsolute? = nil, onStraightNormalized: OnStraightNormalized? = nil, oppositeIntersection: OppositeIntersection? = nil, twoStraightsIntersection: TwoStraightsIntersection? = nil, free: Free? = nil) {
//      self.circumcenter = circumcenter
//      self.intersection = intersection
//      self.onCircular = onCircular
//      self.fixed = fixed
//      self.onStraightAbsolute = onStraightAbsolute
//      self.onStraightNormalized = onStraightNormalized
//      self.oppositeIntersection = oppositeIntersection
//      self.twoStraightsIntersection = twoStraightsIntersection
//      self.free = free
//    }
//  }
//  
//  public func toProxy() throws -> Proxy {
//    switch self.parameters {
//    case let ._circumcenter(point0, point1, point2): return .init(circumcenter: [point0, point1, point2].map{ $0.key.value })
//    case let ._intersection(intersection, index): return .init(intersection: .init(intersection: intersection.key.value, index: index))
//    case let ._onCircular(circular, cursor: cursor): return .init(onCircular: .init(circular: circular.key.value, cursorValue: cursor.value.value))
//    case let .fixed(position): return .init(fixed: .init(x: position.x.value, y: position.y.value))
//    case let ._onStraightAbsolute(straight, cursor: cursor): return .init(onStraightAbsolute: .init(straight: straight.key.value, cursorValue: cursor.value.value))
//    case let ._onStraightNormalized(straight, cursor: cursor): return .init(onStraightNormalized: .init(straight: straight.key.value, cursorValue: cursor.value))
//    case let ._oppositeIntersection(intersection, oppositePoint): return .init(oppositeIntersection: .init(intersection: intersection.key.value, oppositePoint: oppositePoint.key.value))
//    case let ._twoStraightsIntersection(straight0, straight1): return .init(twoStraightsIntersection: [straight0.key.value, straight1.key.value])
//    case let .free(cursor): return .init(free: .init(x: cursor.value.x.value, y: cursor.value.y.value))
//    }
//  }
//}
