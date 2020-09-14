@testable import TMDb
import XCTest

class ProductionCountryTests: XCTestCase {

    func testIDReturnsISO31661() {
        XCTAssertEqual(productionCountry.id, productionCountry.iso31661)
    }

    func testDecodeReturnsProductionCountry() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ProductionCountry.self, from: data)

        XCTAssertEqual(result, productionCountry)
    }

    private let json = """
    {
        "iso_3166_1": "US",
        "name": "United States of America"
    }
    """

    private let productionCountry = ProductionCountry(
        iso31661: "US",
        name: "United States of America"
    )

}
