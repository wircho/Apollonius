public protocol Curve: Figure {
    var knownPoints: [AnyWeakPoint<T>] { get set }
}

