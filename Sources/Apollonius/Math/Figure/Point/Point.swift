public protocol Point: Figure {
    var xy: XY<T>? { get }
    var knownCurves: [AnyWeakCurve<T>] { get set }
}
