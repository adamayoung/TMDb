//
//  URL+QueryItemTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import TMDb
import XCTest

final class URLQueryItemTests: XCTestCase {

    func testAppendingIntPathComponentReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path/2"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingPathComponent(2)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItemWhenNoQueryItemsReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingQueryItem(name: "a", value: "b")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingQueryItemWhenContainsQueryItemsReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&c=d"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingQueryItem(name: "c", value: "d")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKeyWhenNoQueryItemsReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?api_key=123456"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingAPIKeyWhenContainsQueryItemsReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&api_key=123456"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingAPIKey("123456")

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?language=\(languageCode)"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleWithoutLanguageCodeReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingLanguage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingLanguageWithLocaleWithoutRegionCodeReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?language=\(languageCode)"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingImageLanguageWithLocaleReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?include_image_language=\(languageCode),null"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingImageLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingImageLanguageWithLocaleWithoutLanguageCodeReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingImageLanguage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingImageLanguageWithLocaleWithoutRegionCodeReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?include_image_language=\(languageCode),null"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingImageLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingImageLanguageWithLocaleWhenContainsQueryItemsReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&include_image_language=\(languageCode),null"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingImageLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingVideoLanguageWithLocaleReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?include_video_language=en,null"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingVideoLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingVideoLanguageWithLocaleWithoutLanguageCodeReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingVideoLanguage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingVideoLanguageWithLocaleWithoutRegionCodeReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?include_video_language=en,null"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingVideoLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingVideoLanguageWithLocaleWhenContainsQueryItemsReturnsURL() throws {
        let languageCode = "en"
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&include_video_language=en,null"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingVideoLanguage(languageCode)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingPage(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsLessThan1ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?page=1"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsLessThan1ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&page=1"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingPage(0)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsBetween1and1000ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?page=500"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsBetween1and1000ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&page=500"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingPage(500)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenNoQueryItemsAndPageIsGreaterThan1000ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?page=1000"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingPageWhenContainsQueryItemAndPageIsGreaterThan1000ReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&page=1000"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingPage(1001)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenNoQueryItemsAndYearIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenContainsQueryItemAndYearIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenNoQueryItemsAndYearIsNotNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?year=2020"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingYearWhenContainsQueryItemAndYearIsNotNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&year=2020"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenNoQueryItemsAndYearIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenContainsQueryItemAndYearIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingFirstAirDateYear(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenNoQueryItemsAndYearIsNotNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?first_air_date_year=2020"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingFirstAirDateYearWhenContainsQueryItemAndYearIsNotNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&first_air_date_year=2020"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingFirstAirDateYear(2020)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenNoQueryItemsAndWithPeopleIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleIsNilReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingWithPeople(nil)

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenNoQueryItemsAndWithPeopleHasOneElementReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?with_people=1"))

        let result = try XCTUnwrap(URL(string: "/some/path")).appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleHasOneElementReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&with_people=1"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingWithPeople([1])

        XCTAssertEqual(result, expectedResult)
    }

    func testAppendingWithPeopleWhenContainsQueryItemAndWithPeopleHasTwoElementsReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?a=b&with_people=1,2"))

        let result = try XCTUnwrap(URL(string: "/some/path?a=b")).appendingWithPeople([1, 2])

        XCTAssertEqual(result, expectedResult)
    }

}
