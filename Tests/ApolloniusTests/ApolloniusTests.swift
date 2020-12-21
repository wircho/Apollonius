import XCTest
@testable import Apollonius
import Numerics

final class ApolloniusTests: XCTestCase {
  
  func testCanvas() throws {
    // initialization and undo manager parameters
    let canvas = Canvas(allowsUndo: true)
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
  
  func testReadme0() throws {
    let canvas = Canvas()
    let firstPoint = canvas.point(at: 0, 0)
    let secondPoint = canvas.point(at: 3, 4)
    let circle = canvas.circle(centeredAt: firstPoint, through: secondPoint)
    let line = canvas.line(firstPoint, secondPoint)
    print(circle.radius!) // 5.0
    print(line.directionAngle!) // 0.9272952180016122
  }
  
  func testReadme1() throws {
    let canvas = Canvas()
    let center = canvas.point(at: 0, 0)
    let handle = canvas.pointHandle(at: 3, 4)
    let circle = canvas.circle(centeredAt: center, through: handle.point)
    print(circle.radius!) // 5.0
    handle.move(to: 5, 12)
    print(circle.radius!) // 13.0
  }
  
  func testReadme2() throws {
    // Free point moving to (5, 12) in 8000 steps
    let canvas = Canvas()
    let center = canvas.point(at: 0, 0)
    let handle = canvas.pointHandle(at: 3, 4)
    let circle = canvas.circle(centeredAt: center, through: handle.point)
    print("circle.radius = \(circle.radius!)")
    let startTime = CFAbsoluteTimeGetCurrent()
    for i in 1 ... 1000 {
      handle.move(to: 3 + Double(i) / 500, 4 + Double(i) / 125)
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("circle.radius became \(circle.radius!) in \(endTime - startTime) seconds")
    // circle.radius = 5.0
    // circle.radius became 13.0 in 0.04095292091369629 seconds
  }
  
  func testReadme3() throws {
    // Free point moving SMOOTHLY to (5, 12) in 8000 steps
    let canvas = Canvas()
    let center = canvas.point(at: 0, 0)
    let handle = canvas.pointHandle(at: 3, 4)
    let circle = canvas.circle(centeredAt: center, through: handle.point)
    print("circle.radius = \(circle.radius!)")
    handle.beginSmoothMove()
    let startTime = CFAbsoluteTimeGetCurrent()
    for i in 1 ... 1000 {
      handle.move(to: 3 + Double(i) / 500, 4 + Double(i) / 125)
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    handle.endSmoothMove()
    print("circle.radius became \(circle.radius!) in \(endTime - startTime) seconds")
    // circle.radius = 5.0
    // circle.radius became 13.0 in 0.009337067604064941 seconds
  }

  static var allTests = [
    ("testCanvas", testCanvas),
    ("testReadme0", testReadme0),
    ("testReadme1", testReadme1),
    ("testReadme2", testReadme2),
    ("testReadme3", testReadme3)
  ]
}
