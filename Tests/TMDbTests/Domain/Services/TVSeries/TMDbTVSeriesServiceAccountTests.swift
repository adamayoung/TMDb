//
//  TMDbTVSeriesServiceAccountTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceAccountTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("accountStates returns account states")
    func accountStatesReturnsAccountStates() async throws {
        let expectedResult = AccountStates.mock()
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAccountStatesRequest(id: tvSeriesID, sessionID: session.sessionID)

        let result = try await service.accountStates(forTVSeries: tvSeriesID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAccountStatesRequest == expectedRequest)
    }

    @Test("accountStates when errors throws error")
    func accountStatesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.accountStates(forTVSeries: tvSeriesID, session: session)
        }
    }

    @Test("addRating with valid rating succeeds")
    func addRatingWithValidRatingSucceeds() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.5
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = TVSeriesAddRatingRequest(
            rating: rating,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        try await service.addRating(rating, toTVSeries: tvSeriesID, session: session)

        #expect(apiClient.lastRequest as? TVSeriesAddRatingRequest == expectedRequest)
    }

    @Test("addRating with rating too low throws invalidRating error")
    func addRatingWithRatingTooLowThrowsInvalidRatingError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 0.0

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(rating, toTVSeries: tvSeriesID, session: session)
        }
    }

    @Test("addRating with rating too high throws invalidRating error")
    func addRatingWithRatingTooHighThrowsInvalidRatingError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 10.5

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(rating, toTVSeries: tvSeriesID, session: session)
        }
    }

    @Test("addRating with rating not multiple of 0.5 throws invalidRating error")
    func addRatingWithRatingNotMultipleOfHalfThrowsInvalidRatingError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.3

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(rating, toTVSeries: tvSeriesID, session: session)
        }
    }

    @Test("addRating when errors throws error")
    func addRatingWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        let rating = 8.5
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addRating(rating, toTVSeries: tvSeriesID, session: session)
        }
    }

    @Test("deleteRating succeeds")
    func deleteRatingSucceeds() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = TVSeriesDeleteRatingRequest(
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        try await service.deleteRating(forTVSeries: tvSeriesID, session: session)

        #expect(apiClient.lastRequest as? TVSeriesDeleteRatingRequest == expectedRequest)
    }

    @Test("deleteRating when errors throws error")
    func deleteRatingWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.deleteRating(forTVSeries: tvSeriesID, session: session)
        }
    }

}
