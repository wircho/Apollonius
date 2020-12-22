import Numerics

extension XY {
  static func circumcenter<T: Real & Codable>(_ xy0: XY<T>, _ xy1: XY<T>, _ xy2: XY<T>) -> XY<T>? {
    let (v1, v2) = (xy1 - xy0, xy2 - xy0)
    let (s1, s2) = (v1.normSquared(), v2.normSquared())
    let denominator = 2 * (v1 >< v2)
    let numeratorX = v2.dy.length * s1 - v1.dy.length * s2
    let numeratorY = v1.dx.length * s2 - v2.dx.length * s1
    guard let centerDiffX = (numeratorX / denominator)?.value, let centerDiffY = (numeratorY / denominator)?.value else { return nil }
    let centerDiff = DXY<T>(dx: .init(value: centerDiffX), dy: .init(value: centerDiffY))
    return xy0 + centerDiff
  }
}
