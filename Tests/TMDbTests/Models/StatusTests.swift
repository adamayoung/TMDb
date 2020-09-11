@testable import TMDb
import XCTest

class StatusTests: XCTestCase {

    func testRumoredStatus_returnsRawValue() {
        XCTAssertEqual(Status.rumored.rawValue, "Rumored")
    }

    func testPlannedStatus_returnsRawValue() {
        XCTAssertEqual(Status.planned.rawValue, "Planned")
    }

    func testInProductionStatus_returnsRawValue() {
        XCTAssertEqual(Status.inProduction.rawValue, "In Production")
    }

    func testPostProductionStatus_returnsRawValue() {
        XCTAssertEqual(Status.postProduction.rawValue, "Post Production")
    }

    func testReleasedStatus_returnsRawValue() {
        XCTAssertEqual(Status.released.rawValue, "Released")
    }

    func testCanceledStatus_returnsRawValue() {
        XCTAssertEqual(Status.canceled.rawValue, "Canceled")
    }

}
