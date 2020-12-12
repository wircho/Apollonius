import XCTest
@testable import Apollonius
import Numerics

enum StandardCanvasMeta: CanvasMetaProtocol {
  struct Info: FigureInfo { init() {} }
  struct PointStyle: FigureStyle { init() {} }
  struct StraightStyle: FigureStyle { init() {} }
  struct CircularStyle: FigureStyle { init() {} }
}

typealias StandardCanvas<T: Real & Codable> = Canvas<T, StandardCanvasMeta>

final class ApolloniusTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual("Hello, World!", "Hello, World!")
  }
    
  func testCanvas() throws {
    let canvas = StandardCanvas<Double>()
    let center = canvas.point(at: 0, 0)
    let tip = canvas.point(at: 1, 0)
    let circle = canvas.circle(centeredAt: center, through: tip)
    XCTAssert(circle.shape.value?.center.x.value == 0 && circle.shape.value?.center.y.value == 0)
    XCTAssert(circle.shape.value?.radius.value == 1)
    let json = try canvas.toJSONString()
    print(json)
  }
  
  
  func testDynamicCanvas() throws {
    let canvas = StandardCanvas<Double>()
    canvas.undoManager.levelsOfUndo = 10
    canvas.undoManager.groupsByEvent = false
    let center = canvas.pointHandle(at: 0, 0)
    let tip = canvas.point(at: 1, 0)
    center.move(to: 3, 4)
    canvas.undoManager.undo()
    let circle = canvas.circle(centeredAt: center.point, through: tip)
    XCTAssert(circle.shape.value?.center.x.value == 0 && circle.shape.value?.center.y.value == 0)
    XCTAssert(circle.shape.value?.radius.value == 1)
    let json = try canvas.toJSONString()
    print(json)
  }

  static var allTests = [
    ("testExample", testExample),
    ("testCanvas", testCanvas),
    ("testDynamicCanvas", testDynamicCanvas)
  ]
}
