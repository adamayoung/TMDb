@testable import TMDb
import XCTest

class TMDbErrorTests: XCTestCase {

    func testNetworkReturnsErrorDescription() {
        let urlError = URLError(.badURL)
        let expectedResult = urlError.localizedDescription

        let result = TMDbError.network(urlError).localizedDescription

        XCTAssertEqual(result, expectedResult)
    }

    func testUnauthorizedReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.unauthorized.localizedDescription, "Unauthorised")
    }

    func testNotFoundReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.notFound.localizedDescription, "Not Found")
    }

    func testUnknownReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.unknown.localizedDescription, "Unknown Error")
    }

    func testDecodeReturnsErrorDescription() {
        let error = URLError(.badURL)

        let result = TMDbError.decode(error).localizedDescription

        XCTAssertEqual(result, "Data Decode Error")
    }

}
