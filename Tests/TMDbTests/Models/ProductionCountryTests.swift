@testable import TMDb
import XCTest

final class ProductionCountryTests: XCTestCase {

    func testIDReturnsISO31661() {
        XCTAssertEqual(productionCountry.id, productionCountry.countryCode)
    }

    func testDecodeReturnsProductionCountry() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(ProductionCountry.self, fromResource: "production-country")

        XCTAssertEqual(result.countryCode, productionCountry.countryCode)
        XCTAssertEqual(result.name, productionCountry.name)
    }

    private let productionCountry = ProductionCountry(
        countryCode: "US",
        name: "United States of America"
    )

}
