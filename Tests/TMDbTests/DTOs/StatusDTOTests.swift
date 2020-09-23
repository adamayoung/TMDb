@testable import TMDb
import XCTest

class StatusDTOTests: XCTestCase {

    func testRumoredStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.rumored.rawValue, "Rumored")
    }

    func testPlannedStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.planned.rawValue, "Planned")
    }

    func testInProductionStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.inProduction.rawValue, "In Production")
    }

    func testPostProductionStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.postProduction.rawValue, "Post Production")
    }

    func testReleasedStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.released.rawValue, "Released")
    }

    func testCanceledStatusReturnsRawValue() {
        XCTAssertEqual(StatusDTO.canceled.rawValue, "Canceled")
    }

}
