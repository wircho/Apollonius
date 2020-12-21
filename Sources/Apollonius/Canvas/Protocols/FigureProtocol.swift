import Numerics

public protocol FigureProtocol: AnyObject {
  associatedtype T: Real & Codable
  var key: ObjectIdentifier { get }
}
