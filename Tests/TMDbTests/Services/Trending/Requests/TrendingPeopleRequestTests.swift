@testable import TMDb
import XCTest

final class TrendingPeopleRequestTests: XCTestCase {

    func testPathWithDayTimeWindow() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.path, "/trending/person/day")
    }

    func testPathWithWeekTimeWindow() {
        let request = TrendingPeopleRequest(timeWindow: .week, page: nil)

        XCTAssertEqual(request.path, "/trending/person/week")
    }

    func testQueryItemsAreEmpty() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWithPage() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: 1)

        XCTAssertEqual(request.queryItems, ["page": "1"])
    }

    func testMethodIsGet() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = TrendingPeopleRequest(timeWindow: .day, page: nil)

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
