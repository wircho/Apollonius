extension Geometry.Circular {
  struct Value {
    let center: XY<T>
    let radius: Length<T>
    let interval: AngleInterval<T>?
  }
}
