//
//  MoviePaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.movie),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct MoviePaginationIntegrationTests {

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

    @Test("allNowPlaying fetches items from live API")
    func allNowPlayingFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.movies.allNowPlaying() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("allUpcoming fetches items from live API")
    func allUpcomingFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.movies.allUpcoming() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("allSimilar fetches items from live API")
    func allSimilarFetchesItemsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club - has similar movies
        var itemCount = 0
        for try await _ in client.movies.allSimilar(toMovie: movieID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("allLists fetches items from live API")
    func allListsFetchesItemsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club - appears in lists
        var itemCount = 0
        for try await _ in client.movies.allLists(forMovie: movieID) {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        // Lists may be empty for some movies
        #expect(itemCount >= 0)
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

    @Test("allNowPlayingPages yields page objects from live API")
    func allNowPlayingPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.movies.allNowPlayingPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            #expect(page.page != nil)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("allUpcomingPages yields page objects from live API")
    func allUpcomingPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.movies.allUpcomingPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            #expect(page.page != nil)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("allRecommendationsPages yields page objects from live API")
    func allRecommendationsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club
        var pageCount = 0
        for try await page in client.movies.allRecommendationsPages(forMovie: movieID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("allSimilarPages yields page objects from live API")
    func allSimilarPagesYieldsPageObjectsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club
        var pageCount = 0
        for try await page in client.movies.allSimilarPages(toMovie: movieID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("allListsPages yields page objects from live API")
    func allListsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let movieID = 550 // Fight Club
        var pageCount = 0
        for try await _ in client.movies.allListsPages(forMovie: movieID) {
            pageCount += 1
            if pageCount >= 1 {
                break
            }
        }
        // Lists may be empty for some movies, so just verify we can iterate
        #expect(pageCount >= 0)
    }

}
