//
//  DiscoverPaginationIntegrationTests.swift
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
    .tags(.discover),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct DiscoverPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        self.client = CredentialHelper.shared.makeClient()
    }

    @Test("discover allMovies fetches items from live API")
    func discoverAllMoviesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.discover.allMovies() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("discover allMoviesPages yields page objects from live API")
    func discoverAllMoviesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.discover.allMoviesPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("discover allTVSeries fetches items from live API")
    func discoverAllTVSeriesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.discover.allTVSeries() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("discover allTVSeriesPages yields page objects from live API")
    func discoverAllTVSeriesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.discover.allTVSeriesPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

}
