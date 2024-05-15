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

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TVSeriesService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: nil)

        let result = try await service.details(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRequest, expectedRequest)
    }

    func testDetailsWithLanguageReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: language)

        let result = try await service.details(forTVSeries: tvSeriesID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRequest, expectedRequest)
    }

    func testCreditsReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesCreditsRequest(id: tvSeriesID, language: nil)

        let result = try await service.credits(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesCreditsRequest, expectedRequest)
    }

    func testCreditsWithLanguageReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesCreditsRequest(id: tvSeriesID, language: language)

        let result = try await service.credits(forTVSeries: tvSeriesID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesCreditsRequest, expectedRequest)
    }

    func testAggregateCreditsReturnsShowsCredits() async throws {
        let expectedResult = TVSeriesAggregateCredits(id: 1, cast: [], crew: [])
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: nil)

        let result = try await service.aggregateCredits(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesAggregateCreditsRequest, expectedRequest)
    }

    func testAggregateCreditsWithLanguageReturnsShowsCredits() async throws {
        let expectedResult = TVSeriesAggregateCredits(id: 1, cast: [], crew: [])
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: language)

        let result = try await service.aggregateCredits(forTVSeries: tvSeriesID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesAggregateCreditsRequest, expectedRequest)
    }

    func testReviewsReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesReviewsRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.reviews(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesReviewsRequest, expectedRequest)
    }

    func testReviewsWithLanguageReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let language = "en"
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesReviewsRequest(id: tvSeriesID, page: nil, language: language)

        let result = try await service.reviews(forTVSeries: tvSeriesID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesReviewsRequest, expectedRequest)
    }

    func testImagesReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: nil)

        let result = try await service.images(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesImagesRequest, expectedRequest)
    }

    func testImagesWithFilterReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let languages = ["en-GB", "fr"]
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesImageFilter(languages: languages)
        let result = try await service.images(forTVSeries: tvSeriesID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesImagesRequest, expectedRequest)
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: nil)

        let result = try await service.videos(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesVideosRequest, expectedRequest)
    }

    func testVideosWithFilterReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        let languages = ["en", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesVideoFilter(languages: languages)
        let result = try await service.videos(forTVSeries: tvSeriesID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesVideosRequest, expectedRequest)
    }

    func testRecommendationsReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.recommendations(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRecommendationsRequest, expectedRequest)
    }

    func testRecommendationsWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(id: tvSeriesID, page: page, language: language)

        let result = try await service.recommendations(forTVSeries: tvSeriesID, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRecommendationsRequest, expectedRequest)
    }

    func testSimilarReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.similar(toTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarTVSeriesRequest, expectedRequest)
    }

    func testSimilarWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: language)

        let result = try await service.similar(toTVSeries: tvSeriesID, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarTVSeriesRequest, expectedRequest)
    }

    func testPopularReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: nil, language: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularTVSeriesRequest, expectedRequest)
    }

    func testPopularWithPageAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: page, language: language)

        let result = try await service.popular(page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularTVSeriesRequest, expectedRequest)
    }

    func testWatchReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let tvSeriesID = 1
        let country = "GB"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result = try await service.watchProviders(forTVSeries: tvSeriesID, country: country)

        XCTAssertEqual(result, expectedResult.results[country])
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchProvidersRequest, expectedRequest)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = TVSeriesExternalLinksCollection.lockeAndKey
        let tvSeriesID = 86423
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let result = try await service.externalLinks(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesExternalLinksRequest, expectedRequest)
    }

}
