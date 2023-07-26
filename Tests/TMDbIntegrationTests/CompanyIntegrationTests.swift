import TMDb
import XCTest

final class CompanyIntegrationTests: XCTestCase {

    var companyService: CompanyService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        companyService = CompanyService()
    }

    override func tearDown() {
        companyService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let companyID = 82968

        let company = try await companyService.details(forCompany: companyID)

        XCTAssertEqual(company.id, companyID)
        XCTAssertEqual(company.name, "LuckyChap Entertainment")
    }

}
