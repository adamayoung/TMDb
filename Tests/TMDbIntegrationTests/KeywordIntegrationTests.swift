//
//  KeywordIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.keyword),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct KeywordIntegrationTests {

    var keywordService: (any KeywordService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.keywordService = TMDbClient(apiKey: apiKey).keywords
    }

    @Test("details")
    func details() async throws {
        let keywordID = 378

        let keyword = try await keywordService.details(forKeyword: keywordID)

        #expect(keyword.id == keywordID)
        #expect(keyword.name == "prison")
    }

    @Test("movies")
    func movies() async throws {
        let keywordID = 378

        let movieList = try await keywordService.movies(forKeyword: keywordID)

        #expect(movieList.results.isEmpty == false)
        #expect((movieList.page ?? 0) >= 1)
        #expect((movieList.totalResults ?? 0) >= 1)
    }

    @Test("movies with page and language")
    func moviesWithPageAndLanguage() async throws {
        let keywordID = 378

        let movieList = try await keywordService.movies(
            forKeyword: keywordID,
            page: 1,
            language: "en"
        )

        #expect(movieList.results.isEmpty == false)
        #expect(movieList.page == 1)
    }

}
