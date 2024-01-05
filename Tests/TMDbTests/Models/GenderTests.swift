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

    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"gender\": 9}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).gender

        XCTAssertEqual(result, .unknown)
    }

}

extension GenderTests {

    private struct MockObject: Decodable {
        let gender: Gender
    }

}
