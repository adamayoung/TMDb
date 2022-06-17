@testable import TMDb
import XCTest

final class URLTMDbTests: XCTestCase {

    func testTMDbAPIBaseURLRetunsCorrectURL() {
        let expectedResult = URL(string: "https://api.themoviedb.org/3")!

        let result = URL.tmdbAPIBaseURL

        XCTAssertEqual(result, expectedResult)
    }

}
