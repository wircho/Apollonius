import Numerics

public enum CanvasItem<T: Real> {
  case point(Canvas<T>.Point)
}

public final class Canvas<T: Real> {
  var itemArray: [CanvasItem<T>] = []
}
