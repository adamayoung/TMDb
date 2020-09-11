@testable import TMDb
import XCTest

class URLQueryItemTests: XCTestCase {

    func testAppendingIntPathComponent_returnsURL() {
        let expectedResult = URL(string: "/some/path/2")!

        let result = URL(string: "/some/path")!.appendingPathComponent(2)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItem_whenNoQueryItems_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path")!.appendingQueryItem(name: "a", value: "b")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItem_whenContainsQueryItems_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&c=d")!

        let result = URL(string: "/some/path?a=b")!.appendingQueryItem(name: "c", value: "d")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKey_whenNoQueryItems_returnsURL() {
        let expectedResult = URL(string: "/some/path?api_key=123456")!

        let result = URL(string: "/some/path")!.appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKey_whenContainsQueryItems_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&api_key=123456")!

        let result = URL(string: "/some/path?a=b")!.appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenNoQueryItemsAndPageIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenContainsQueryItemAndPageIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenNoQueryItemsAndPageIsLessThan1_returnsURL() {
        let expectedResult = URL(string: "/some/path?page=1")!

        let result = URL(string: "/some/path")!.appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenContainsQueryItemAndPageIsLessThan1_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=1")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenNoQueryItemsAndPageIsBetween1and1000_returnsURL() {
        let expectedResult = URL(string: "/some/path?page=500")!

        let result = URL(string: "/some/path")!.appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenContainsQueryItemAndPageIsBetween1and1000_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=500")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenNoQueryItemsAndPageIsGreaterThan1000_returnsURL() {
        let expectedResult = URL(string: "/some/path?page=1000")!

        let result = URL(string: "/some/path")!.appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPage_whenContainsQueryItemAndPageIsGreaterThan1000_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=1000")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYear_whenNoQueryItemsAndYearIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYear_whenContainsQueryItemAndYearIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYear_whenNoQueryItemsAndYearIsNotNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?year=2020")!

        let result = URL(string: "/some/path")!.appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYear_whenContainsQueryItemAndYearIsNotNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&year=2020")!

        let result = URL(string: "/some/path?a=b")!.appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYear_whenNoQueryItemsAndYearIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYear_whenContainsQueryItemAndYearIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYear_whenNoQueryItemsAndYearIsNotNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?first_air_date_year=2020")!

        let result = URL(string: "/some/path")!.appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYear_whenContainsQueryItemAndYearIsNotNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&first_air_date_year=2020")!

        let result = URL(string: "/some/path?a=b")!.appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }



    func testAppendingWithPeople_whenNoQueryItemsAndWithPeopleIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeople_whenContainsQueryItemAndWithPeopleIsNil_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeople_whenNoQueryItemsAndWithPeopleHasOneElement_returnsURL() {
        let expectedResult = URL(string: "/some/path?with_people=1")!

        let result = URL(string: "/some/path")!.appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeople_whenContainsQueryItemAndWithPeopleHasOneElement_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&with_people=1")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeople_whenContainsQueryItemAndWithPeopleHasTwoElements_returnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&with_people=1,2")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople([1, 2])

        XCTAssertEqual(result, expectedResult)
    }

}
