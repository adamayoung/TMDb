@testable import TMDb
import XCTest

class GenderTests: XCTestCase {

    func testUnknownGender_returnsRawValue() {
        XCTAssertEqual(Gender.unknown.rawValue, 0)
    }

    func testFemaleGender_returnsRawValue() {
        XCTAssertEqual(Gender.female.rawValue, 1)
    }

    func testMaleGender_returnsRawValue() {
        XCTAssertEqual(Gender.male.rawValue, 2)
    }

    func testOtherGender_returnsRawValue() {
        XCTAssertEqual(Gender.other.rawValue, 3)
    }

}
