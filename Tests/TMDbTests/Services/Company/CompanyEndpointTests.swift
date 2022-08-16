@testable import TMDb
import XCTest

final class CompanyEndpointTests: XCTestCase {

    func testCompanyEndpointReturnsURL() {
        let expectedURL = URL(string: "/company/1")!

        let url = CompanyEndpoint.details(companyID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
