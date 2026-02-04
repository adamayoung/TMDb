//
//  TMDbMovieServiceTranslationsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceTranslationsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("translations returns translations for movie")
    func translationsReturnsTranslationsForMovie() async throws {
        let expectedResult = TranslationCollection<MovieTranslationData>.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieTranslationsRequest(id: movieID)

        let result = try await service.translations(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieTranslationsRequest == expectedRequest)
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(forMovie: movieID)
        }
    }

}
