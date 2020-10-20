import XCTest
@testable import Apollonius
import Numerics

final class ApolloniusTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual("Hello, World!", "Hello, World!")
        
    }
    
    func testSegmentPointToPoint() {
        let x0 = 123.123123
        let y0 = 546546.45645
        let x1 = 39435.3453
        let y1 = 90019.238
        let p0 = FreePoint(x: x0, y: y0)
        let p1 = FreePoint(x: x1, y: y1)
        let s = SegmentPointToPoint(point0: p0, point1: p1)
        p0.update()
        p1.update()
        s.update()
        XCTAssertEqual(s.xy0?.x.value, x0)
        XCTAssertEqual(s.xy0?.y.value, y0)
        XCTAssertEqual(s.xy1?.x.value, x1)
        XCTAssertEqual(s.xy1?.y.value, y1)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

// MARK: - Figure type tests

typealias PointTest<F: Point & Figure> = F
typealias SegmentTest<F: Segment & Straight & Curve & Figure> = F
typealias LineTest<F: Line & Straight & Curve & Figure> = F
typealias RayTest<F: Ray & Straight & Curve & Figure> = F

typealias FreePointTest<T: Real> = PointTest<FreePoint<T>>
typealias SegmentPointToPointTest<T: Real> = SegmentTest<SegmentPointToPoint<T>>
typealias LinePointToPointTest<T: Real> = LineTest<LinePointToPoint<T>>
typealias RayPointToPointTest<T: Real> = RayTest<RayPointToPoint<T>>
