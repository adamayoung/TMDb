@testable import TMDb
import XCTest

final class TrendingTimeWindowFilterTypeTests: XCTestCase {

    func testDayReturnsRawValue() {
        let expectedResult = "day"

        let result = TrendingTimeWindowFilterType.day.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testWeekReturnsRawValue() {
        let expectedResult = "week"

        let result = TrendingTimeWindowFilterType.week.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}
