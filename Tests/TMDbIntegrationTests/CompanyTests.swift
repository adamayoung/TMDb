@testable import TMDb
import XCTest

final class CompanyTests: XCTestCase {

    private var tmdb: TMDbAPI!

    override func setUpWithError() throws {
        super.setUp()
        tmdb = TMDbAPI(apiKey: "", urlSessionConfiguration: .integrationTest)
    }

    override func tearDown() {
        tmdb = nil
        TMDbURLProtocol.reset()
        super.tearDown()
    }

    func testDetails() async throws {
        let companyID = 3
        TMDbURLProtocol.add("company-details", for: CompanyEndpoint.details(companyID: companyID))

        let company = try await tmdb.companies.details(forCompany: companyID)

        XCTAssertEqual(company.id, companyID)
    }

}
