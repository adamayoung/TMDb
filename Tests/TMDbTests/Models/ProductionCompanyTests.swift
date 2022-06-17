@testable import TMDb
import XCTest

final class ProductionCompanyTests: XCTestCase {

    func testDecodeReturnsProductionCompany() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(ProductionCompany.self, fromResource: "production-company")

        XCTAssertEqual(result.id, productionCompany.id)
        XCTAssertEqual(result.name, productionCompany.name)
        XCTAssertEqual(result.originCountry, productionCompany.originCountry)
        XCTAssertEqual(result.logoPath, productionCompany.logoPath)
    }

    private let productionCompany = ProductionCompany(
        id: 25,
        name: "20th Century Fox",
        originCountry: "US",
        logoPath: URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
    )

}
