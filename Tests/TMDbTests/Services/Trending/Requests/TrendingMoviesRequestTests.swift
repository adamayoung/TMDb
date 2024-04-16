@testable import TMDb
import XCTest

final class TrendingMoviesRequestTests: XCTestCase {

    func testPathWithDayTimeWindow() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.path, "/trending/movie/day")
    }

    func testPathWithWeekTimeWindow() {
        let request = TrendingMoviesRequest(timeWindow: .week, page: nil)

        XCTAssertEqual(request.path, "/trending/movie/week")
    }

    func testQueryItemsAreEmpty() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithPage() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: 1)

        XCTAssertEqual(request.queryItems, ["page": "1"])
    }

    func testMethodIsGet() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
