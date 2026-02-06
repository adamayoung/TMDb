//
//  TMDbDiscoverServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .discover))
struct TMDbDiscoverServicePaginationTests {

    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbDiscoverService(apiClient: apiClient)
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

        #expect(items.count == 8) // 4 per page × 2 pages
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

}
