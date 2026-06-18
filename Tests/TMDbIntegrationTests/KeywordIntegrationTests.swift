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
    .integrationGate,
    .serialized,
    .tags(.keyword),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct KeywordIntegrationTests {

    var keywordService: (any KeywordService)!

    init() {
        self.keywordService = CredentialHelper.shared.makeClient().keywords
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
        #expect(movieList.page >= 1)
        #expect(movieList.totalResults >= 1)
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

    @Test("allMovies paginates across pages")
    func allMovies() async throws {
        let keywordID = 378

        var items: [MovieListItem] = []
        for try await item in keywordService.allMovies(forKeyword: keywordID).prefix(25) {
            items.append(item)
        }

        #expect(items.isEmpty == false)
    }

}
