//
//  TMDbTVSeriesServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServicePaginationTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    // MARK: - allReviews

    @Test("allReviews yields items from multiple pages")
    func allReviewsYieldsItemsFromMultiplePages() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 2, totalPages: 2)))

        var items: [Review] = []
        for try await item in service.allReviews(forTVSeries: tvSeriesID) {
            items.append(item)
        }

        #expect(items.count == 6) // 3 per page × 2 pages
        #expect(apiClient.requests.count == 2)
    }

    @Test("allReviewsPages yields page objects")
    func allReviewsPagesYieldsPageObjects() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 1, totalPages: 1)))

        var pages: [ReviewPageableList] = []
        for try await page in service.allReviewsPages(forTVSeries: tvSeriesID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allRecommendations

    @Test("allRecommendations yields items from multiple pages")
    func allRecommendationsYieldsItemsFromMultiplePages() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allRecommendations(forTVSeries: tvSeriesID) {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allRecommendationsPages yields page objects")
    func allRecommendationsPagesYieldsPageObjects() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allRecommendationsPages(forTVSeries: tvSeriesID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allSimilar

    @Test("allSimilar yields items from multiple pages")
    func allSimilarYieldsItemsFromMultiplePages() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allSimilar(toTVSeries: tvSeriesID) {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allSimilarPages yields page objects")
    func allSimilarPagesYieldsPageObjects() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allSimilarPages(toTVSeries: tvSeriesID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allLists

    @Test("allLists yields items from multiple pages")
    func allListsYieldsItemsFromMultiplePages() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(MediaPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MediaPageableList.mock(page: 2, totalPages: 2)))

        var items: [Media] = []
        for try await item in service.allLists(forTVSeries: tvSeriesID) {
            items.append(item)
        }

        #expect(items.count == 10) // 5 per page × 2 pages
    }

    @Test("allListsPages yields page objects")
    func allListsPagesYieldsPageObjects() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.success(MediaPageableList.mock(page: 1, totalPages: 1)))

        var pages: [MediaPageableList] = []
        for try await page in service.allListsPages(forTVSeries: tvSeriesID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allPopular

    @Test("allPopular yields items from multiple pages")
    func allPopularYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allPopular() {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allPopularPages yields page objects")
    func allPopularPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allPopularPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allAiringToday

    @Test("allAiringToday yields items from multiple pages")
    func allAiringTodayYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allAiringToday() {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allAiringTodayPages yields page objects")
    func allAiringTodayPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allAiringTodayPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allOnTheAir

    @Test("allOnTheAir yields items from multiple pages")
    func allOnTheAirYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allOnTheAir() {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allOnTheAirPages yields page objects")
    func allOnTheAirPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allOnTheAirPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allTopRated

    @Test("allTopRated yields items from multiple pages")
    func allTopRatedYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allTopRated() {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allTopRatedPages yields page objects")
    func allTopRatedPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allTopRatedPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
