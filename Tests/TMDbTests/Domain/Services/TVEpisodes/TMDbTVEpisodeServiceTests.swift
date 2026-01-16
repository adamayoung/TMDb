//
//  TMDbTVEpisodeServiceTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("details with default parameter values returns TV episode")
    func detailsWithDefaultParameterValuesReturnsTVEpisode() async throws {
        let tvSeriesID = 1
        let expectedResult = TVEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await (service as TVEpisodeService).details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeRequest == expectedRequest)
    }

    @Test("details with language returns TV episode")
    func detailsWithLanguageReturnsTVEpisode() async throws {
        let tvSeriesID = 1
        let expectedResult = TVEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        let episodeNumber = 3
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

    @Test("credits with default parameter values returns TV episode credits")
    func creditsWithDefaultParameterValuesReturnsTVEpisodeCredits() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1
        let expectedResult = ShowCredits(id: 63068, cast: [], crew: [])
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeCreditsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await (service as TVEpisodeService).credits(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeCreditsRequest == expectedRequest)
    }

    @Test("credits with language returns TV episode credits")
    func creditsWithLanguageReturnsTVEpisodeCredits() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1
        let language = "en"
        let expectedResult = ShowCredits(id: 63068, cast: [], crew: [])
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeCreditsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.credits(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeCreditsRequest == expectedRequest)
    }

    @Test("credits when errors throws error")
    func creditsWhenErrorsThrowsError() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.credits(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

    @Test("images with default parameter values returns images")
    func imagesWithDefaultParameterValuesReturnsImages() async throws {
        let episodeNumber = 111
        let seasonNumber = 11
        let tvSeriesID = 1
        let expectedResult = TVEpisodeImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await (service as TVEpisodeService).images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeImagesRequest == expectedRequest)
    }

    @Test("images with filter returns images")
    func imagesWithFilterReturnsImages() async throws {
        let episodeNumber = 111
        let seasonNumber = 11
        let tvSeriesID = 1
        let languages = ["en-GB", "fr"]
        let expectedResult = TVEpisodeImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVEpisodeImageFilter(languages: languages)
        let result = try await service.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        let episodeNumber = 3
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

    @Test("video with default parameter values returns videos")
    func videosWithDefaultParameterValuesReturnsVideos() async throws {
        let episodeNumber = 111
        let seasonNumber = 11
        let tvSeriesID = 1
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await (service as TVEpisodeService).videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeVideosRequest == expectedRequest)
    }

    @Test("video with filter returns videos")
    func videosWithFilterReturnsVideos() async throws {
        let episodeNumber = 111
        let seasonNumber = 11
        let tvSeriesID = 1
        let languages = ["en", "fr"]
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVEpisodeVideoFilter(languages: languages)
        let result = try await service.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVEpisodeVideosRequest == expectedRequest)
    }

    @Test("video when errors throws error")
    func videosWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        let episodeNumber = 3
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.videos(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
