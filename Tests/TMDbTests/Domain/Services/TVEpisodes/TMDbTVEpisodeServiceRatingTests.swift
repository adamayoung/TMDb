//
//  TMDbTVEpisodeServiceRatingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceRatingTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("addRating with valid rating succeeds")
    func addRatingWithValidRatingSucceeds() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.5
        apiClient.addResponse(
            .success(SuccessResult(success: true))
        )
        let expectedRequest = TVEpisodeAddRatingRequest(
            rating: rating,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        try await service.addRating(
            rating,
            toEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            session: session
        )

        #expect(
            apiClient.lastRequest
                as? TVEpisodeAddRatingRequest
                == expectedRequest
        )
    }

    @Test("addRating with rating too low throws invalidRating error")
    func addRatingTooLowThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 0.0

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(
                rating,
                toEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

    @Test("addRating with rating too high throws invalidRating error")
    func addRatingTooHighThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 10.5

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(
                rating,
                toEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

    @Test("addRating with rating not multiple of 0.5 throws invalidRating error")
    func addRatingNotMultipleOfHalfThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.3

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(
                rating,
                toEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

    @Test("addRating when errors throws error")
    func addRatingWhenErrorsThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.5
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addRating(
                rating,
                toEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

    @Test("deleteRating succeeds")
    func deleteRatingSucceeds() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(
            .success(SuccessResult(success: true))
        )
        let expectedRequest = TVEpisodeDeleteRatingRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        try await service.deleteRating(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            session: session
        )

        #expect(
            apiClient.lastRequest
                as? TVEpisodeDeleteRatingRequest
                == expectedRequest
        )
    }

    @Test("deleteRating when errors throws error")
    func deleteRatingWhenErrorsThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.deleteRating(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

}
