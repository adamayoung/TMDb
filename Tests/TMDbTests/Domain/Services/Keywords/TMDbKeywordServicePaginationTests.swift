//
//  TMDbKeywordServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .keyword))
struct TMDbKeywordServicePaginationTests {

    var service: TMDbKeywordService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbKeywordService(apiClient: apiClient)
    }

    // MARK: - allMovies

    @Test("allMovies yields items from multiple pages")
    func allMoviesYieldsItemsFromMultiplePages() async throws {
        let page1 = MoviePageableList.mock(page: 1, totalPages: 2)
        let page2 = MoviePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MovieListItem] = []
        for try await item in service.allMovies(forKeyword: 1, language: "en") {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is KeywordMoviesRequest)
    }

    @Test("allMoviesPages yields page objects")
    func allMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var pages: [MoviePageableList] = []
        for try await page in service.allMoviesPages(forKeyword: 1) {
            pages.append(page)
        }

        #expect(pages.count == 2)
        let firstPage = try #require(pages.first)
        #expect(firstPage.page == 1)
        #expect(firstPage.totalPages == 2)
    }

}
