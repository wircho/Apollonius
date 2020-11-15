import Numerics

func circumcenter<T: Real & Codable>(_ xy0: XY<T>, _ xy1: XY<T>, _ xy2: XY<T>) -> XY<T>? {
  let (v0, v1, v2) = (xy0 - xy2, xy1 - xy0, xy2 - xy1)
  let (s0, s2) = (v0.normSquared(), v2.normSquared())
  let (d0, d1) = (v0 • v1, v1 • v2)
  let den = 2 * (v1 >< v2).squared()
  let (num0, num1) = (s2 * d0, s0 * d1)
  guard let t0 = num0 / den, let t1 = num1 / den else { return nil }
  let center0 = xy0 + (1 - t0) * (xy1 - xy0)
  let center = center0 + (1 - t0 - t1) * (xy2 - xy1)
  return center
}
