//
//  TMDbTVSeasonServiceTests.swift
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

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("details returns TV season")
    func detailsReturnsTVSeason() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await service.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonRequest == expectedRequest)
    }

    @Test("details with language returns TV season")
    func detailsWithLanguageReturnsTVSeason() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.details(
            forSeason: seasonNumber, inTVSeries: tvSeriesID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)
        }
    }

    @Test("aggregateCredits returns TV season credits")
    func aggregateCreditsReturnsTVSeasonCredits() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeasonAggregateCredits(id: 1, cast: [], crew: [])
        let seasonNumber = Int.randomID
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await service.aggregateCredits(
            forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonAggregateCreditsRequest == expectedRequest)
    }

    @Test("aggregateCredits with language returns TV season credits")
    func aggregateCreditsWithLanguageReturnsTVSeasonCredits() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeasonAggregateCredits(id: 1, cast: [], crew: [])
        let seasonNumber = Int.randomID
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.aggregateCredits(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonAggregateCreditsRequest == expectedRequest)
    }

    @Test("aggregateCredits when errors throws error")
    func aggregateCreditsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.aggregateCredits(forSeason: seasonNumber, inTVSeries: tvSeriesID)
        }
    }

    @Test("imagess returns images")
    func imagesReturnsImages() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeasonImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await service.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonImagesRequest == expectedRequest)
    }

    @Test("images with filter returns images")
    func imagesWithFilterReturnsImages() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let languages = ["en-GB", "fr"]
        let expectedResult = TVSeasonImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVSeasonImageFilter(languages: languages)
        let result = try await service.images(
            forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)
        }
    }

    @Test("videos returns videos")
    func videosReturnsVideos() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await service.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonVideosRequest == expectedRequest)
    }

    @Test("videos with filter returns videos")
    func videosWithFilterReturnsVideos() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let languages = ["en", "fr"]
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVSeasonVideoFilter(languages: languages)
        let result = try await service.videos(
            forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonVideosRequest == expectedRequest)
    }

    @Test("videos when errors throws error")
    func videosWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)
        }
    }

}
