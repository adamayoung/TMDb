@testable import TMDb
import XCTest

class TMDbErrorTests: XCTestCase {

    func testNetwork_returnsErrorDescription() {
        let urlError = URLError(.badURL)
        let expectedResult = urlError.localizedDescription

        let result = TMDbError.network(urlError).localizedDescription

        XCTAssertEqual(result, expectedResult)
    }

    func testUnauthorized_returnsErrorDescription() {
        XCTAssertEqual(TMDbError.unauthorized.localizedDescription, "Unauthorised")
    }

    func testNotFound_returnsErrorDescription() {
        XCTAssertEqual(TMDbError.notFound.localizedDescription, "Not Found")
    }

    func testUnknown_returnsErrorDescription() {
        XCTAssertEqual(TMDbError.unknown.localizedDescription, "Unknown Error")
    }

    func testDecode_returnsErrorDescription() {
        let error = URLError(.badURL)

        let result = TMDbError.decode(error).localizedDescription

        XCTAssertEqual(result, "Data Decode Error")
    }

}
