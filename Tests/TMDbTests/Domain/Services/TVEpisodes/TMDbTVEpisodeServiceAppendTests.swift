//
//  TMDbTVEpisodeServiceAppendTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceAppendTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("details with append returns response")
    func detailsWithAppendReturnsResponse() async throws {
        let expectedResult = TVEpisodeDetailsResponse(
            episode: .mock()
        )
        let tvSeriesID = 1
        let seasonNumber = expectedResult.episode.seasonNumber
        let episodeNumber = expectedResult.episode.episodeNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            appendToResponse: [.credits, .images],
            language: nil
        )

        let result = try await (service as TVEpisodeService).details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            appending: [.credits, .images]
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVEpisodeDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append and language returns response")
    func detailsWithAppendAndLanguageReturnsResponse() async throws {
        let expectedResult = TVEpisodeDetailsResponse(
            episode: .mock()
        )
        let tvSeriesID = 1
        let seasonNumber = expectedResult.episode.seasonNumber
        let episodeNumber = expectedResult.episode.episodeNumber
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            appendToResponse: .credits,
            language: language
        )

        let result = try await service.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            appending: .credits,
            language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVEpisodeDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append when errors throws error")
    func detailsWithAppendWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        let episodeNumber = 3
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                appending: .credits
            )
        }
    }

}
