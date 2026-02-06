//
//  TMDbMovieServiceAppendTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceAppendTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("details with append returns response")
    func detailsWithAppendReturnsResponse() async throws {
        let expectedResult = MovieDetailsResponse(
            movie: .thorLoveAndThunder
        )
        let movieID = expectedResult.movie.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieDetailsAppendRequest(
            id: movieID,
            appendToResponse: [.credits, .images],
            language: nil
        )

        let result = try await (service as MovieService).details(
            forMovie: movieID,
            appending: [.credits, .images]
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? MovieDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append and language returns response")
    func detailsWithAppendAndLanguageReturnsResponse() async throws {
        let expectedResult = MovieDetailsResponse(
            movie: .thorLoveAndThunder
        )
        let movieID = expectedResult.movie.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieDetailsAppendRequest(
            id: movieID,
            appendToResponse: .credits,
            language: language
        )

        let result = try await service.details(
            forMovie: movieID,
            appending: .credits,
            language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? MovieDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append when errors throws error")
    func detailsWithAppendWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forMovie: movieID,
                appending: .credits
            )
        }
    }

}
