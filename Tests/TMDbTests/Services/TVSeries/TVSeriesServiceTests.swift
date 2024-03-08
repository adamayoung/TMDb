//
//  TVSeriesServiceTests.swift
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

final class TVSeriesServiceTests: XCTestCase {

    var service: TVSeriesService!
    var apiClient: MockAPIClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        service = TVSeriesService(apiClient: apiClient, localeProvider: localeProvider)
    }

    override func tearDown() {
        apiClient = nil
        localeProvider = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testCreditsReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.credits(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.credits(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testImagesReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.images(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastRequestURL,
            TVSeriesEndpoint.images(tvSeriesID: tvSeriesID, languageCode: localeProvider.languageCode).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.videos(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastRequestURL,
            TVSeriesEndpoint.videos(tvSeriesID: tvSeriesID, languageCode: localeProvider.languageCode).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsWithDefaultParametersReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsWithPageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastRequestURL,
            TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID, page: page).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarWithDefaultParametersReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarWithPageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularWithDefaultParametersReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.popular().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.popular().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularWithPageReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.popular(page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testWatchReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.watchProviders(forTVSeries: tvSeriesID)

        let regionCode = try XCTUnwrap(localeProvider.regionCode)
        XCTAssertEqual(result, expectedResult.results[regionCode])
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.watch(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = TVSeriesExternalLinksCollection.lockeAndKey
        let tvSeriesID = 86423
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.externalLinks(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TVSeriesEndpoint.externalIDs(tvSeriesID: tvSeriesID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

}
