//
//  TrendingPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.trending),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TrendingPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("trending allMovies fetches items from live API")
    func trendingAllMoviesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.trending.allMovies() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("trending allTVSeries fetches items from live API")
    func trendingAllTVSeriesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.trending.allTVSeries() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("trending allMoviesPages yields page objects from live API")
    func trendingAllMoviesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.trending.allMoviesPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("trending allPeople fetches items from live API")
    func trendingAllPeopleFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.trending.allPeople() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("trending allPeoplePages yields page objects from live API")
    func trendingAllPeoplePagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.trending.allPeoplePages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("trending allTVSeriesPages yields page objects from live API")
    func trendingAllTVSeriesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.trending.allTVSeriesPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("trending allTrending fetches items from live API")
    func trendingAllTrendingFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.trending.allTrending() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("trending allTrendingPages yields page objects from live API")
    func trendingAllTrendingPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.trending.allTrendingPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

}
