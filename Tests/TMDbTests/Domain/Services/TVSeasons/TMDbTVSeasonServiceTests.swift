//
//  TMDbTVSeasonServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

    @Test("details with default parameter values returns TV season")
    func detailsWithDefaultParameterValuesReturnsTVSeason() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await (service as TVSeasonService).details(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonRequest == expectedRequest)
    }

    @Test("details with language returns TV season")
    func detailsWithLanguageReturnsTVSeason() async throws {
        let tvSeriesID = 1
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
            forSeason: seasonNumber, inTVSeries: tvSeriesID, language: language
        )

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

    @Test("aggregateCredits with default parameter values returns TV season credits")
    func aggregateCreditsWithDefaultParameterValuesReturnsTVSeasonCredits() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeasonAggregateCredits(id: 1, cast: [], crew: [])
        let seasonNumber = 11
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await (service as TVSeasonService).aggregateCredits(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonAggregateCreditsRequest == expectedRequest)
    }

    @Test("aggregateCredits with language returns TV season credits")
    func aggregateCreditsWithLanguageReturnsTVSeasonCredits() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeasonAggregateCredits(id: 1, cast: [], crew: [])
        let seasonNumber = 11
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

    @Test("credits with default parameter values returns TV season credits")
    func creditsWithDefaultParameterValuesReturnsTVSeasonCredits() async throws {
        let tvSeriesID = 1
        let expectedResult = ShowCredits(id: 3625, cast: [], crew: [])
        let seasonNumber = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await (service as TVSeasonService).credits(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonCreditsRequest == expectedRequest)
    }

    @Test("credits with language returns TV season credits")
    func creditsWithLanguageReturnsTVSeasonCredits() async throws {
        let tvSeriesID = 1
        let expectedResult = ShowCredits(id: 3625, cast: [], crew: [])
        let seasonNumber = 2
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.credits(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonCreditsRequest == expectedRequest)
    }

    @Test("credits when errors throws error")
    func creditsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.credits(forSeason: seasonNumber, inTVSeries: tvSeriesID)
        }
    }

    @Test("imagess with default parameter values returns images")
    func imagesWithDefaultParameterValuesReturnsImages() async throws {
        let seasonNumber = 11
        let tvSeriesID = 1
        let expectedResult = TVSeasonImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await (service as TVSeasonService).images(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonImagesRequest == expectedRequest)
    }

    @Test("images with filter returns images")
    func imagesWithFilterReturnsImages() async throws {
        let seasonNumber = 11
        let tvSeriesID = 1
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
            forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter
        )

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

    @Test("videos with default parameter values returns videos")
    func videosWithDefaultParameterValuesReturnsVideos() async throws {
        let seasonNumber = 11
        let tvSeriesID = 1
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await (service as TVSeasonService).videos(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeasonVideosRequest == expectedRequest)
    }

    @Test("videos with filter returns videos")
    func videosWithFilterReturnsVideos() async throws {
        let seasonNumber = 11
        let tvSeriesID = 1
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
            forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter
        )

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
