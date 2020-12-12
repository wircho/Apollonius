import Foundation

public extension Canvas {
  func toJSON() throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return try JSONEncoder().encode(simplified())
  }
  
  func toJSONString() throws -> String {
    return try .init(decoding: toJSON(), as: UTF8.self)
  }
  
  func from(json: Data) throws -> Canvas {
    return try .from(simplified: JSONDecoder().decode(Canvas.Simplified.self, from: json))
  }
}
