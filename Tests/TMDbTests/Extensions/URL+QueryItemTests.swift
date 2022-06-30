@testable import TMDb
import XCTest

final class URLQueryItemTests: XCTestCase {

    func testAppendingIntPathComponentReturnsURL() {
        let expectedResult = URL(string: "/some/path/2")!

        let result = URL(string: "/some/path")!.appendingPathComponent(2)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItemWhenNoQueryItemsReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path")!.appendingQueryItem(name: "a", value: "b")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItemWhenContainsQueryItemsReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&c=d")!

        let result = URL(string: "/some/path?a=b")!.appendingQueryItem(name: "c", value: "d")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKeyWhenNoQueryItemsReturnsURL() {
        let expectedResult = URL(string: "/some/path?api_key=123456")!

        let result = URL(string: "/some/path")!.appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKeyWhenContainsQueryItemsReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&api_key=123456")!

        let result = URL(string: "/some/path?a=b")!.appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleReturnsURL() {
        let locale = Locale(identifier: "en_GB")
        let expectedResult = URL(string: "/some/path?language=en")!

        let result = URL(string: "/some/path")!.appendingLanguage(locale: locale)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleWithoutLanguageCodeReturnsURL() {
        let locale = Locale(identifier: "")
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingLanguage(locale: locale)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleWithoutRegionCodeReturnsURL() {
        let locale = Locale(identifier: "en")
        let expectedResult = URL(string: "/some/path?language=en")!

        let result = URL(string: "/some/path")!.appendingLanguage(locale: locale)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleWhenContainsQueryItemsReturnsURL() {
        let locale = Locale(identifier: "en_GB")
        let expectedResult = URL(string: "/some/path?a=b&language=en")!

        let result = URL(string: "/some/path?a=b")!.appendingLanguage(locale: locale)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsLessThan1ReturnsURL() {
        let expectedResult = URL(string: "/some/path?page=1")!

        let result = URL(string: "/some/path")!.appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsLessThan1ReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=1")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsBetween1and1000ReturnsURL() {
        let expectedResult = URL(string: "/some/path?page=500")!

        let result = URL(string: "/some/path")!.appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsBetween1and1000ReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=500")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsGreaterThan1000ReturnsURL() {
        let expectedResult = URL(string: "/some/path?page=1000")!

        let result = URL(string: "/some/path")!.appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsGreaterThan1000ReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&page=1000")!

        let result = URL(string: "/some/path?a=b")!.appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenNoQueryItemsAndYearIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenContainsQueryItemAndYearIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenNoQueryItemsAndYearIsNotNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?year=2020")!

        let result = URL(string: "/some/path")!.appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenContainsQueryItemAndYearIsNotNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&year=2020")!

        let result = URL(string: "/some/path?a=b")!.appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenNoQueryItemsAndYearIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenContainsQueryItemAndYearIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenNoQueryItemsAndYearIsNotNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?first_air_date_year=2020")!

        let result = URL(string: "/some/path")!.appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenContainsQueryItemAndYearIsNotNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&first_air_date_year=2020")!

        let result = URL(string: "/some/path?a=b")!.appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenNoQueryItemsAndWithPeopleIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path")!

        let result = URL(string: "/some/path")!.appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleIsNilReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenNoQueryItemsAndWithPeopleHasOneElementReturnsURL() {
        let expectedResult = URL(string: "/some/path?with_people=1")!

        let result = URL(string: "/some/path")!.appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleHasOneElementReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&with_people=1")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleHasTwoElementsReturnsURL() {
        let expectedResult = URL(string: "/some/path?a=b&with_people=1,2")!

        let result = URL(string: "/some/path?a=b")!.appendingWithPeople([1, 2])

        XCTAssertEqual(result, expectedResult)
    }

}
