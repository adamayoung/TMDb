//
//  TMDbSearchServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .search))
struct TMDbSearchServicePaginationTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    // MARK: - allMulti

    @Test("allMulti yields items from multiple pages")
    func allMultiYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(MediaPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MediaPageableList.mock(page: 2, totalPages: 2)))

        var items: [Media] = []
        for try await item in service.allMulti(query: query) {
            items.append(item)
        }

        #expect(items.count == 10) // 5 per page × 2 pages
        #expect(apiClient.requests.count == 2)
    }

    @Test("allMultiPages yields page objects")
    func allMultiPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(MediaPageableList.mock(page: 1, totalPages: 1)))

        var pages: [MediaPageableList] = []
        for try await page in service.allMultiPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allMovies

    @Test("allMovies yields items from multiple pages")
    func allMoviesYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allMovies(query: query) {
            items.append(item)
        }

        #expect(items.count == 8)
    }

    @Test("allMoviesPages yields page objects")
    func allMoviesPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allMoviesPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allTVSeries

    @Test("allTVSeries yields items from multiple pages")
    func allTVSeriesYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 2, totalPages: 2)))

        var items: [TVSeriesListItem] = []
        for try await item in service.allTVSeries(query: query) {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allTVSeriesPages yields page objects")
    func allTVSeriesPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allTVSeriesPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allPeople

    @Test("allPeople yields items from multiple pages")
    func allPeopleYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(PersonPageableList.mock(page: 2, totalPages: 2)))

        var items: [PersonListItem] = []
        for try await item in service.allPeople(query: query) {
            items.append(item)
        }

        #expect(items.count == 8) // 4 per page × 2 pages
    }

    @Test("allPeoplePages yields page objects")
    func allPeoplePagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 1)))

        var pages: [PersonPageableList] = []
        for try await page in service.allPeoplePages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allCollections

    @Test("allCollections yields items from multiple pages")
    func allCollectionsYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(CollectionPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(CollectionPageableList.mock(page: 2, totalPages: 2)))

        var items: [CollectionListItem] = []
        for try await item in service.allCollections(query: query) {
            items.append(item)
        }

        #expect(items.count == 6)
    }

    @Test("allCollectionsPages yields page objects")
    func allCollectionsPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(CollectionPageableList.mock(page: 1, totalPages: 1)))

        var pages: [CollectionPageableList] = []
        for try await page in service.allCollectionsPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allCompanies

    @Test("allCompanies yields items from multiple pages")
    func allCompaniesYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(CompanyPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(CompanyPageableList.mock(page: 2, totalPages: 2)))

        var items: [ProductionCompany] = []
        for try await item in service.allCompanies(query: query) {
            items.append(item)
        }

        #expect(items.count == 6)
    }

    @Test("allCompaniesPages yields page objects")
    func allCompaniesPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(CompanyPageableList.mock(page: 1, totalPages: 1)))

        var pages: [CompanyPageableList] = []
        for try await page in service.allCompaniesPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allKeywords

    @Test("allKeywords yields items from multiple pages")
    func allKeywordsYieldsItemsFromMultiplePages() async throws {
        let query = "test"
        apiClient.addResponse(.success(KeywordPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(KeywordPageableList.mock(page: 2, totalPages: 2)))

        var items: [Keyword] = []
        for try await item in service.allKeywords(query: query) {
            items.append(item)
        }

        #expect(items.count == 6)
    }

    @Test("allKeywordsPages yields page objects")
    func allKeywordsPagesYieldsPageObjects() async throws {
        let query = "test"
        apiClient.addResponse(.success(KeywordPageableList.mock(page: 1, totalPages: 1)))

        var pages: [KeywordPageableList] = []
        for try await page in service.allKeywordsPages(query: query) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
