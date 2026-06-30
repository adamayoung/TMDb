//
//  TMDbMovieServiceRatingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceRatingTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("addRating with valid rating succeeds")
    func addRatingWithValidRatingSucceeds() async throws {
        let movieID = 1
        let session = Session.mock()
        let rating = 8.5
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddMovieRatingRequest(
            rating: rating,
            movieID: movieID,
            sessionID: session.sessionID
        )

        try await service.addRating(rating, toMovie: movieID, session: session)

        #expect(apiClient.lastRequest as? AddMovieRatingRequest == expectedRequest)
    }

    @Test("addRating with rating too low throws invalidRating and performs no request")
    func addRatingTooLowThrowsInvalidRating() async throws {
        let session = Session.mock()

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(0.0, toMovie: 1, session: session)
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("addRating with rating too high throws invalidRating and performs no request")
    func addRatingTooHighThrowsInvalidRating() async throws {
        let session = Session.mock()

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(10.5, toMovie: 1, session: session)
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("addRating with rating not a multiple of 0.5 throws invalidRating and performs no request")
    func addRatingOffStepThrowsInvalidRating() async throws {
        let session = Session.mock()

        await #expect(throws: TMDbError.invalidRating) {
            try await service.addRating(8.3, toMovie: 1, session: session)
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("addRating when errors throws error")
    func addRatingWhenErrorsThrowsError() async throws {
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addRating(8.5, toMovie: 1, session: session)
        }
    }

}
