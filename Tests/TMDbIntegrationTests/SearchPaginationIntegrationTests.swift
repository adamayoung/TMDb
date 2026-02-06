//
//  SearchPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.search),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct SearchPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("search allMovies fetches items from live API")
    func searchAllMoviesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allMovies(query: "Matrix") {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("search allMulti fetches items from live API")
    func searchAllMultiFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allMulti(query: "Star Wars") {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("search allMoviesPages yields page objects from live API")
    func searchAllMoviesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allMoviesPages(query: "Spider") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

}
