//
//  TMDbChangesServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .changes))
struct TMDbChangesServicePaginationTests {

    var service: TMDbChangesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbChangesService(apiClient: apiClient)
    }

    // MARK: - allMovieChanges

    @Test("allMovieChanges yields items from multiple pages and caps at totalPages")
    func allMovieChangesYieldsItemsFromMultiplePages() async throws {
        let page1 = ChangedIDCollection.mock(page: 1, totalPages: 2)
        let page2 = ChangedIDCollection.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [ChangedID] = []
        for try await item in service.allMovieChanges() {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is MovieChangesListRequest)
    }

    @Test("allMovieChangesPages yields page objects")
    func allMovieChangesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(ChangedIDCollection.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(ChangedIDCollection.mock(page: 2, totalPages: 2)))

        var pages: [PageableListResult<ChangedID>] = []
        for try await page in service.allMovieChangesPages() {
            pages.append(page)
        }

        #expect(pages.count == 2)
        let firstPage = try #require(pages.first)
        #expect(firstPage.page == 1)
        #expect(firstPage.totalPages == 2)
    }

    // MARK: - allTVSeriesChanges

    @Test("allTVSeriesChanges yields items from multiple pages")
    func allTVSeriesChangesYieldsItemsFromMultiplePages() async throws {
        let page1 = ChangedIDCollection.mock(page: 1, totalPages: 2)
        let page2 = ChangedIDCollection.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [ChangedID] = []
        for try await item in service.allTVSeriesChanges() {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is TVSeriesChangesListRequest)
    }

    @Test("allTVSeriesChangesPages yields page objects")
    func allTVSeriesChangesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(ChangedIDCollection.mock(page: 1, totalPages: 1)))

        var pages: [PageableListResult<ChangedID>] = []
        for try await page in service.allTVSeriesChangesPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allPersonChanges

    @Test("allPersonChanges yields items from multiple pages")
    func allPersonChangesYieldsItemsFromMultiplePages() async throws {
        let page1 = ChangedIDCollection.mock(page: 1, totalPages: 2)
        let page2 = ChangedIDCollection.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [ChangedID] = []
        for try await item in service.allPersonChanges() {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is PersonChangesListRequest)
    }

    @Test("allPersonChangesPages yields page objects")
    func allPersonChangesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(ChangedIDCollection.mock(page: 1, totalPages: 1)))

        var pages: [PageableListResult<ChangedID>] = []
        for try await page in service.allPersonChangesPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - ChangedID Identifiable

    @Test("ChangedID id is the changed media identifier")
    func changedIDIdentifiableIDIsMediaID() {
        let changedID = ChangedID(id: 42, adult: false)

        #expect(changedID.id == 42)
    }

}
