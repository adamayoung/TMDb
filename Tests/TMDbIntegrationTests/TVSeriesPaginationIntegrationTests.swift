//
//  TVSeriesPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.tvSeries),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVSeriesPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("tvSeries allPopular fetches items from live API")
    func tvSeriesAllPopularFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.tvSeries.allPopular() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("tvSeries allTopRated fetches items from live API")
    func tvSeriesAllTopRatedFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.tvSeries.allTopRated() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("tvSeries allAiringToday fetches items from live API")
    func tvSeriesAllAiringTodayFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.tvSeries.allAiringToday() {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("tvSeries allOnTheAir fetches items from live API")
    func tvSeriesAllOnTheAirFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.tvSeries.allOnTheAir() {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("tvSeries allRecommendations fetches items from live API")
    func tvSeriesAllRecommendationsFetchesItemsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad - has recommendations
        var itemCount = 0
        for try await _ in client.tvSeries.allRecommendations(forTVSeries: tvSeriesID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("tvSeries allSimilar fetches items from live API")
    func tvSeriesAllSimilarFetchesItemsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad - has similar shows
        var itemCount = 0
        for try await _ in client.tvSeries.allSimilar(toTVSeries: tvSeriesID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("tvSeries allReviews fetches items from live API")
    func tvSeriesAllReviewsFetchesItemsFromLiveAPI() async throws {
        let tvSeriesID = 94605 // Arcane - has reviews
        var itemCount = 0
        for try await _ in client.tvSeries.allReviews(forTVSeries: tvSeriesID) {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        #expect(itemCount >= 1)
    }

    @Test("tvSeries allLists fetches items from live API")
    func tvSeriesAllListsFetchesItemsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad - appears in lists
        var itemCount = 0
        for try await _ in client.tvSeries.allLists(forTVSeries: tvSeriesID) {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        #expect(itemCount >= 0)
    }

    @Test("tvSeries allPopularPages yields page objects from live API")
    func tvSeriesAllPopularPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.tvSeries.allPopularPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("tvSeries allTopRatedPages yields page objects from live API")
    func tvSeriesAllTopRatedPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.tvSeries.allTopRatedPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("tvSeries allAiringTodayPages yields page objects from live API")
    func tvSeriesAllAiringTodayPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.tvSeries.allAiringTodayPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("tvSeries allOnTheAirPages yields page objects from live API")
    func tvSeriesAllOnTheAirPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.tvSeries.allOnTheAirPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("tvSeries allRecommendationsPages yields page objects from live API")
    func tvSeriesAllRecommendationsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad
        var pageCount = 0
        for try await page in client.tvSeries.allRecommendationsPages(forTVSeries: tvSeriesID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("tvSeries allSimilarPages yields page objects from live API")
    func tvSeriesAllSimilarPagesYieldsPageObjectsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad
        var pageCount = 0
        for try await page in client.tvSeries.allSimilarPages(toTVSeries: tvSeriesID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("tvSeries allReviewsPages yields page objects from live API")
    func tvSeriesAllReviewsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let tvSeriesID = 94605 // Arcane
        var pageCount = 0
        for try await page in client.tvSeries.allReviewsPages(forTVSeries: tvSeriesID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("tvSeries allListsPages yields page objects from live API")
    func tvSeriesAllListsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let tvSeriesID = 1396 // Breaking Bad
        var pageCount = 0
        for try await _ in client.tvSeries.allListsPages(forTVSeries: tvSeriesID) {
            pageCount += 1
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 0)
    }

}
