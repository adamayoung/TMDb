@testable import TMDb
import XCTest

final class TMDbErrorTests: XCTestCase {

    func testNetworkReturnsErrorDescription() {
        let urlError = URLError(.badURL)
        let expectedResult = urlError.localizedDescription

        let result = TMDbError.network(urlError).localizedDescription

        XCTAssertEqual(result, expectedResult)
    }

    func testUnauthorizedReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.unauthorised(nil).localizedDescription, "Unauthorised")
    }

    func testNotFoundReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.notFound(nil).localizedDescription, "Not found")
    }

    func testUnknownReturnsErrorDescription() {
        XCTAssertEqual(TMDbError.unknown.localizedDescription, "Unknown error")
    }

    func testDecodeReturnsErrorDescription() {
        let error = URLError(.badURL)

        let result = TMDbError.decode(error).localizedDescription

        XCTAssertEqual(result, "The operation couldn’t be completed. (NSURLErrorDomain error -1000.)")
    }

}
