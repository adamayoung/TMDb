//
//  TMDbTrendingServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .trending))
struct TMDbTrendingServicePaginationTests {

    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTrendingService(apiClient: apiClient)
    }

    // MARK: - allMovies

    @Test("allMovies yields items from multiple pages")
    func allMoviesYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allMovies() {
            items.append(item)
        }

        #expect(items.count == 8)
        #expect(apiClient.requests.count == 2)
    }

    @Test("allMoviesPages yields page objects")
    func allMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allMoviesPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allTVSeries

    @Test("allTVSeries yields items from multiple pages")
    func allTVSeriesYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allTVSeries() {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allTVSeriesPages yields page objects")
    func allTVSeriesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allTVSeriesPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allPeople

    @Test("allPeople yields items from multiple pages")
    func allPeopleYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(PersonPageableList.mock(page: 2, totalPages: 2)))

        var items: [PersonListItem] = []
        for try await item in service.allPeople() {
            items.append(item)
        }

        #expect(items.count == 8) // 4 per page × 2 pages
    }

    @Test("allPeoplePages yields page objects")
    func allPeoplePagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 1)))

        var pages: [PersonPageableList] = []
        for try await page in service.allPeoplePages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allTrending

    @Test("allTrending yields items from multiple pages")
    func allTrendingYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(TrendingPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TrendingPageableList.mock(page: 2, totalPages: 2)))

        var items: [TrendingItem] = []
        for try await item in service.allTrending() {
            items.append(item)
        }

        #expect(items.count == 6)
    }

    @Test("allTrendingPages yields page objects")
    func allTrendingPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TrendingPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TrendingPageableList] = []
        for try await page in service.allTrendingPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
