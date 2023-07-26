@testable import TMDb
import XCTest

final class URLTMDbTests: XCTestCase {

    func testTMDbAPIBaseURLReturnsCorrectURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "https://api.themoviedb.org/3"))

        let result = URL.tmdbAPIBaseURL

        XCTAssertEqual(result, expectedResult)
    }

}
