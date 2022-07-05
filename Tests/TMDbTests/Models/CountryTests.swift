@testable import TMDb
import XCTest

final class CountryTests: XCTestCase {

    func testDecodeReturnsCountry() throws {
        let expectedResult = Country(countryCode: "US", name: "United States", englishName: "United States of America")

        let result = try JSONDecoder.theMovieDatabase.decode(Country.self, fromResource: "configuration-country")

        XCTAssertEqual(result.id, expectedResult.countryCode)
        XCTAssertEqual(result.countryCode, expectedResult.countryCode)
        XCTAssertEqual(result.name, expectedResult.name)
        XCTAssertEqual(result.englishName, expectedResult.englishName)
    }

}
