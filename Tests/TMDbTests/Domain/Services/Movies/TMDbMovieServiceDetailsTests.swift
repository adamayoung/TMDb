//
//  TMDbMovieServiceDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceDetailsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("details with default parameter values returns movie")
    func detailsWithDefaultParameterValuesReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: movieID, language: nil)

        let result = try await (service as MovieService).details(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieRequest == expectedRequest)
    }

    @Test("details with language returns movie")
    func detailsWithLanguageReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: movieID, language: language)

        let result = try await service.details(forMovie: movieID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forMovie: movieID)
        }
    }

}
