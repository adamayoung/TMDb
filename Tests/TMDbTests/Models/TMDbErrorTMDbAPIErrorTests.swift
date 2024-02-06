@testable import TMDb
import XCTest

final class TMDbErrorTMDbAPIErrorTests: XCTestCase {

    func testInitWithNonTMDbAPIErrorReturnsUnknownError() {
        let error = NSError(domain: "test", code: -1)

        let tmdbError = TMDbError(error: error)

        XCTAssertEqual(tmdbError, .unknown)
    }

    func testInitWithNotFoundTMDbAPIErrorReturnsNotFoundError() {
        let error = TMDbAPIError.notFound(nil)

        let tmdbError = TMDbError(error: error)

        XCTAssertEqual(tmdbError, .notFound)
    }

    func testInitWithUnauthorisedTMDbAPIErrorReturnsNotFoundError() {
        let error = TMDbAPIError.notFound(nil)

        let tmdbError = TMDbError(error: error)

        XCTAssertEqual(tmdbError, .notFound)
    }

}
