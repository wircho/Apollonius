public protocol StraightPhantom {
    associatedtype T: FloatingPoint
    func containsNormalizedValue(_ value: T) -> Bool
}
