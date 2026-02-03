//
//  TMDbKeywordServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .keyword))
struct TMDbKeywordServiceTests {

    var service: TMDbKeywordService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbKeywordService(apiClient: apiClient)
    }

    @Test("details returns keyword")
    func detailsReturnsKeyword() async throws {
        let expectedResult = Keyword.prison
        let keywordID = expectedResult.id
        let expectedRequest = KeywordRequest(id: keywordID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(forKeyword: keywordID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? KeywordRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let keywordID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forKeyword: keywordID)
        }
    }

    @Test("movies returns movie pageable list")
    func moviesReturnsMoviePageableList() async throws {
        let keywordID = 378
        let expectedResult = MoviePageableList.mock()
        let expectedRequest = KeywordMoviesRequest(id: keywordID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(forKeyword: keywordID, page: nil, language: nil)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? KeywordMoviesRequest == expectedRequest)
    }

    @Test("movies with page and language returns movie pageable list")
    func moviesWithPageAndLanguageReturnsMoviePageableList() async throws {
        let keywordID = 378
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        let expectedRequest = KeywordMoviesRequest(id: keywordID, page: page, language: language)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(forKeyword: keywordID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? KeywordMoviesRequest == expectedRequest)
    }

    @Test("movies when errors throws error")
    func moviesWhenErrorsThrowsError() async throws {
        let keywordID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movies(forKeyword: keywordID, page: nil, language: nil)
        }
    }

}
