import Numerics

infix operator •: MultiplicationPrecedence
infix operator ><: MultiplicationPrecedence

protocol Coordinate: Dimension {}

struct X<T: Real & Codable>: Coordinate {
    let value: T
    init(value: T) { self.value = value }
}

struct Y<T: Real & Codable>: Coordinate {
    let value: T
    init(value: T) { self.value = value }
}

struct XY<T: Real & Codable> {
  var x: X<T>
  var y: Y<T>
  
  init(x: X<T>, y: Y<T>) {
    self.x = x
    self.y = y
  }
}

extension Length {
    var asDX: X<T>.Difference { return .init(value: value) }
    var asDY: Y<T>.Difference { return .init(value: value) }
}
