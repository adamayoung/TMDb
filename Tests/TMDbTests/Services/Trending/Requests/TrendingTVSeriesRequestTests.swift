@testable import TMDb
import XCTest

final class TrendingTVSeriesRequestTests: XCTestCase {

    func testPathWithDayTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.path, "/trending/tv/day")
    }

    func testPathWithWeekTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .week, page: nil)

        XCTAssertEqual(request.path, "/trending/tv/week")
    }

    func testQueryItemsAreEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithPage() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: 1)

        XCTAssertEqual(request.queryItems, ["page": "1"])
    }

    func testMethodIsGet() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
