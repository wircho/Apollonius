import Foundation
import Numerics

public final class Canvas<T: Real & Codable, Meta: CanvasMetaProtocol> {
  public typealias Info = Meta.Info
  public typealias PointStyle = Meta.PointStyle
  public typealias StraightStyle = Meta.StraightStyle
  public typealias CircularStyle = Meta.CircularStyle
  public typealias ScalarStyle = EmptyScalarStyle
  typealias IntersectionStyle = EmptyIntersectionStyle
  
  public let undoManager = UndoManager()
  var items: OrderedDictionary<ObjectIdentifier, Item> = [:]
  var pointHandles: Dictionary<ObjectIdentifier, PointHandle> = [:]
}
