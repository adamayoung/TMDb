//
//  ImagesConfiguration+URLsTests.swift
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

import TMDb
import XCTest

final class ImagesConfigurationURLsTests: XCTestCase {

    var configuration: ImagesConfiguration!
    var emptyConfiguration: ImagesConfiguration!

    override func setUp() {
        super.setUp()
        configuration = ImagesConfiguration(
            baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
            secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
        emptyConfiguration = ImagesConfiguration(
            baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
            secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [],
            profileSizes: [],
            stillSizes: []
        )
    }

    override func tearDown() {
        emptyConfiguration = nil
        configuration = nil
        super.tearDown()
    }

    func testBackdropURLWhenPathIsNilReturnsNil() {
        let result = configuration.backdropURL(for: nil, idealWidth: 0)

        XCTAssertNil(result)
    }

    func testBackdropURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.backdropURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 100_000)

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropURLWhenWidth1280Returns1280URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w1280/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 1280)

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropURLWhenWidth900Returns1280URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w1280/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 900)

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropURLWhenWidth200Returns300URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 200)

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = emptyConfiguration.backdropURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.logoURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 100_000)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenWidth500Returns500URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 500)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenWidth400Returns500URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 400)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenWidth40Returns45URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w45/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 40)

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = emptyConfiguration.logoURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.posterURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 100_000)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenWidth780Returns780URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 780)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenWidth600Returns780URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 600)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenWidth90Returns92URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w92/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 90)

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = emptyConfiguration.posterURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.profileURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 100_000)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenWidth185Returns185URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 185)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenWidth100Returns185URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 100)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenWidth40Returns45URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w45/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 40)

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = emptyConfiguration.profileURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.stillURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 100_000)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenWidth300Returns300URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 300)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenWidth190Returns300URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 190)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenWidth50Returns92URL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/w92/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 50)

        XCTAssertEqual(result, expectedResult)
    }

    func testStillURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try XCTUnwrap(URL(string: "/image.jpg"))
        let expectedResult = try XCTUnwrap(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = emptyConfiguration.stillURL(for: path)

        XCTAssertEqual(result, expectedResult)
    }

}
