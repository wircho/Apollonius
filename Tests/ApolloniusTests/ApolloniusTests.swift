import XCTest
@testable import Apollonius
import Numerics

final class ApolloniusTests: XCTestCase {
  
  func testCanvas() throws {
    // initialization and undo manager parameters
    let canvas = Canvas()
    canvas.levelsOfUndo = 10
    canvas.groupsUndosByEvent = false
    // center at (0, 0)
    let center = canvas.pointHandle(at: 0, 0)
    // tip at (1, 0)
    let tip = canvas.point(at: 1, 0)
    // center moves to (3, 4)
    center.move(to: 3, 4)
    // undo: center moves back to to (3, 4)
    canvas.undo()
    // circle between center and tip
    let circle = canvas.circle(centeredAt: center.point, through: tip)
    // asserts
    XCTAssert(circle.shape.value?.center.x.value == 0 && circle.shape.value?.center.y.value == 0)
    XCTAssert(circle.shape.value?.radius.value == 1)
    // json serialization
    let json = try canvas.toJSONString()
    print(json)
  }

  static var allTests = [
    ("testCanvas", testCanvas)
  ]
}
