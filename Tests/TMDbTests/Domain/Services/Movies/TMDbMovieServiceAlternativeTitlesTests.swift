//
//  TMDbMovieServiceAlternativeTitlesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceAlternativeTitlesTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("alternativeTitles with default parameter values returns alternative titles")
    func alternativeTitlesWithDefaultParameterValuesReturnsAlternativeTitles() async throws {
        let expectedResult = AlternativeTitleCollection.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieAlternativeTitlesRequest(
            id: movieID,
            country: nil,
            language: nil
        )

        let result = try await (service as MovieService).alternativeTitles(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieAlternativeTitlesRequest == expectedRequest)
    }

    @Test("alternativeTitles with country and language returns alternative titles")
    func alternativeTitlesWithCountryAndLanguageReturnsAlternativeTitles() async throws {
        let expectedResult = AlternativeTitleCollection.mock()
        let movieID = 1
        let country = "US"
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieAlternativeTitlesRequest(
            id: movieID,
            country: country,
            language: language
        )

        let result = try await service.alternativeTitles(
            forMovie: movieID,
            country: country,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieAlternativeTitlesRequest == expectedRequest)
    }

    @Test("alternativeTitles when errors throws error")
    func alternativeTitlesWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.alternativeTitles(forMovie: movieID)
        }
    }

}
