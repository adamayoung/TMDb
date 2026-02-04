//
//  TMDbMovieServiceAccountStatesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceAccountStatesTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("accountStates returns account states for movie")
    func accountStatesReturnsAccountStatesForMovie() async throws {
        let expectedResult = AccountStates.mock()
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieAccountStatesRequest(id: movieID, sessionID: session.sessionID)

        let result = try await service.accountStates(forMovie: movieID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieAccountStatesRequest == expectedRequest)
    }

    @Test("accountStates when errors throws error")
    func accountStatesWhenErrorsThrowsError() async throws {
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.accountStates(forMovie: movieID, session: session)
        }
    }

    @Test("addRating adds rating to movie")
    func addRatingAddsRatingToMovie() async throws {
        let rating = 8.5
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddMovieRatingRequest(
            rating: rating,
            movieID: movieID,
            sessionID: session.sessionID
        )

        try await service.addRating(rating, toMovie: movieID, session: session)

        #expect(apiClient.lastRequest as? AddMovieRatingRequest == expectedRequest)
    }

    @Test("addRating when errors throws error")
    func addRatingWhenErrorsThrowsError() async throws {
        let rating = 8.5
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addRating(rating, toMovie: movieID, session: session)
        }
    }

    @Test("deleteRating deletes rating for movie")
    func deleteRatingDeletesRatingForMovie() async throws {
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = DeleteMovieRatingRequest(
            movieID: movieID,
            sessionID: session.sessionID
        )

        try await service.deleteRating(forMovie: movieID, session: session)

        #expect(apiClient.lastRequest as? DeleteMovieRatingRequest == expectedRequest)
    }

    @Test("deleteRating when errors throws error")
    func deleteRatingWhenErrorsThrowsError() async throws {
        let movieID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.deleteRating(forMovie: movieID, session: session)
        }
    }

}
