//
//  PaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.movie),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct PaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    // MARK: - Item-Level Iteration

    @Test("allPopular fetches multiple pages from live API")
    func allPopularFetchesMultiplePagesFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.movies.allPopular() {
            itemCount += 1
            if itemCount >= 25 { // Limit to ~2 pages
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("allPopular with early break stops fetching")
    func allPopularWithEarlyBreakStopsFetching() async throws {
        var itemCount = 0
        for try await _ in client.movies.allPopular() {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        #expect(itemCount == 5)
    }

    @Test("allTopRated fetches items from live API")
    func allTopRatedFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.movies.allTopRated() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("allRecommendations fetches items from live API")
    func allRecommendationsFetchesItemsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club - has recommendations
        var itemCount = 0
        for try await _ in client.movies.allRecommendations(forMovie: movieID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("allReviews fetches items from live API")
    func allReviewsFetchesItemsFromLiveAPI() async throws {
        let movieID = 346_698 // Barbie - has reviews
        var itemCount = 0
        for try await _ in client.movies.allReviews(forMovie: movieID) {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        #expect(itemCount >= 1)
    }

    // MARK: - Page-Level Iteration

    @Test("allPopularPages yields page objects from live API")
    func allPopularPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.movies.allPopularPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            #expect(page.page != nil)
            #expect(page.totalPages != nil)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("allTopRatedPages yields page objects from live API")
    func allTopRatedPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.movies.allTopRatedPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("allReviewsPages yields page objects from live API")
    func allReviewsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let movieID = 346_698 // Barbie
        var pageCount = 0
        for try await page in client.movies.allReviewsPages(forMovie: movieID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

}
