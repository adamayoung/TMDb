@testable import TMDb
import XCTest

class GenderDTOTests: XCTestCase {

    func testUnknownGenderReturnsRawValue() {
        XCTAssertEqual(GenderDTO.unknown.rawValue, 0)
    }

    func testFemaleGenderReturnsRawValue() {
        XCTAssertEqual(GenderDTO.female.rawValue, 1)
    }

    func testMaleGenderReturnsRawValue() {
        XCTAssertEqual(GenderDTO.male.rawValue, 2)
    }

    func testOtherGenderReturnsRawValue() {
        XCTAssertEqual(GenderDTO.other.rawValue, 3)
    }

}
