@testable import TMDb
import XCTest

class TrendingTimeWindowFilterTypeTests: XCTestCase {

    func testDay_returnsRawValue() {
        let expectedResult = "day"

        let result = TrendingTimeWindowFilterType.day.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testWeek_returnsRawValue() {
        let expectedResult = "week"

        let result = TrendingTimeWindowFilterType.week.rawValue

        XCTAssertEqual(result, expectedResult)
    }

    func testDefault_returnsRawValue() {
        let expectedResult = "day"

        let result = TrendingTimeWindowFilterType.default.rawValue

        XCTAssertEqual(result, expectedResult)
    }

}
