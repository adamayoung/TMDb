@testable import TMDb
import XCTest

class URLTMDbTests: XCTestCase {

    func testTMDbAPIBaseURLRetunsCorrectURL() {
        let expectedResult = URL(string: "https://api.themoviedb.org/3")!

        let result = URL.tmdbAPIBaseURL

        XCTAssertEqual(result, expectedResult)
    }

    func testTMDbImageBaseURLRetunsCorrectURL() {
        let expectedResult = URL(string: "https://image.tmdb.org/t/p")!

        let result = URL.tmdbImageBaseURL

        XCTAssertEqual(result, expectedResult)
    }

}
