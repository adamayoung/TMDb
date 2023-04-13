@testable import TMDb
import XCTest

final class TMDbStatusResponseTests: XCTestCase {

    func testDecodeReturnsStatusResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TMDbStatusResponse.self,
                                                             fromResource: "error-status-response")

        XCTAssertEqual(result.success, statusResponse.success)
        XCTAssertEqual(result.statusCode, statusResponse.statusCode)
        XCTAssertEqual(result.statusMessage, statusResponse.statusMessage)
    }

    private let statusResponse = TMDbStatusResponse(
        success: false,
        statusCode: 34,
        statusMessage: "The resource you requested could not be found."
    )

}
