@testable import TMDb
import XCTest

class ProductionCompanyDTOTests: XCTestCase {

    func testDecodeReturnsProductionCompany() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ProductionCompanyDTO.self, from: data)

        XCTAssertEqual(result, productionCompany)
    }

    private let json = """
    {
        "id": 25,
        "logo_path": "/qZCc1lty5FzX30aOCVRBLzaVmcp.png",
        "name": "20th Century Fox",
        "origin_country": "US"
    }
    """

    private let productionCompany = ProductionCompanyDTO(
        id: 25,
        name: "20th Century Fox",
        originCountry: "US",
        logoPath: URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
    )

}
