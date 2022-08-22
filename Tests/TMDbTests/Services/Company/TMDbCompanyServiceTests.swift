@testable import TMDb
import XCTest

final class TMDbCompanyServiceTests: XCTestCase {

    var service: TMDbCompanyService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbCompanyService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsCompany() async throws {
        let expectedResult = Company.lucasfilm
        let companyID = expectedResult.id

        apiClient.result = .success(expectedResult)

        let result = try await service.details(forCompany: companyID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CompanyEndpoint.details(companyID: companyID).path)
    }

}
