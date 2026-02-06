//
//  TMDbPersonServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .people))
struct TMDbPersonServicePaginationTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    // MARK: - allPopular

    @Test("allPopular yields items from multiple pages")
    func allPopularYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(PersonPageableList.mock(page: 2, totalPages: 2)))

        var items: [PersonListItem] = []
        for try await item in service.allPopular() {
            items.append(item)
        }

        #expect(items.count == 8) // 4 per page × 2 pages
    }

    @Test("allPopularPages yields page objects")
    func allPopularPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(PersonPageableList.mock(page: 1, totalPages: 1)))

        var pages: [PersonPageableList] = []
        for try await page in service.allPopularPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allTaggedImages

    @Test("allTaggedImages yields items from multiple pages")
    func allTaggedImagesYieldsItemsFromMultiplePages() async throws {
        let personID = 1
        apiClient.addResponse(.success(TaggedImagePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(TaggedImagePageableList.mock(page: 2, totalPages: 2)))

        var items: [TaggedImage] = []
        for try await item in service.allTaggedImages(forPerson: personID) {
            items.append(item)
        }

        #expect(items.count == 6) // 3 per page × 2 pages
    }

    @Test("allTaggedImagesPages yields page objects")
    func allTaggedImagesPagesYieldsPageObjects() async throws {
        let personID = 1
        apiClient.addResponse(.success(TaggedImagePageableList.mock(page: 1, totalPages: 1)))

        var pages: [TaggedImagePageableList] = []
        for try await page in service.allTaggedImagesPages(forPerson: personID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
