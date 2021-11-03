@testable import TMDb
import XCTest

final class GenderTests: XCTestCase {

    func testUnknownGenderReturnsRawValue() {
        XCTAssertEqual(Gender.unknown.rawValue, 0)
    }

    func testFemaleGenderReturnsRawValue() {
        XCTAssertEqual(Gender.female.rawValue, 1)
    }

    func testMaleGenderReturnsRawValue() {
        XCTAssertEqual(Gender.male.rawValue, 2)
    }

    func testOtherGenderReturnsRawValue() {
        XCTAssertEqual(Gender.other.rawValue, 3)
    }

}
