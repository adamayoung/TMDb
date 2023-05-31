@testable import TMDb
import XCTest

final class CompanyServiceTests: XCTestCase {

    var service: CompanyService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = CompanyService(apiClient: apiClient)
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
