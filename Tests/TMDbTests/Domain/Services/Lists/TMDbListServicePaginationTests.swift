//
//  TMDbListServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .list))
struct TMDbListServicePaginationTests {

    var service: TMDbListService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbListService(apiClient: apiClient)
    }

    // MARK: - allItems

    @Test("allItems yields items from multiple pages")
    func allItemsYieldsItemsFromMultiplePages() async throws {
        let listID = 1
        let page1 = PageableListResult(
            page: 1,
            results: [MediaListItem.mock(id: 1), MediaListItem.mock(id: 2)],
            totalResults: 4,
            totalPages: 2
        )
        let page2 = PageableListResult(
            page: 2,
            results: [MediaListItem.mock(id: 3), MediaListItem.mock(id: 4)],
            totalResults: 4,
            totalPages: 2
        )
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MediaListItem] = []
        for try await item in service.allItems(forList: listID) {
            items.append(item)
        }

        #expect(items.count == 4) // 2 per page × 2 pages
    }

    @Test("allItemsPages yields page objects")
    func allItemsPagesYieldsPageObjects() async throws {
        let listID = 1
        let page = PageableListResult(
            page: 1,
            results: [MediaListItem.mock(id: 1), MediaListItem.mock(id: 2)],
            totalResults: 2,
            totalPages: 1
        )
        apiClient.addResponse(.success(page))

        var pages: [PageableListResult<MediaListItem>] = []
        for try await page in service.allItemsPages(forList: listID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allDetails / allDetailsPages

    // Note: allDetails and allDetailsPages are not testable with standard mocks
    // because they wrap MediaList (non-pageable) into PageableListResult.
    // These methods exist for API consistency but have limited practical use
    // since MediaList.details() typically returns a single object per page.

}
