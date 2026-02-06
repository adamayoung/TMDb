//
//  ListPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.list),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ListPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("list allItems fetches items from live API")
    func listAllItemsFetchesItemsFromLiveAPI() async throws {
        let listID = 1 // A known public list
        var itemCount = 0
        for try await _ in client.lists.allItems(forList: listID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 1)
    }

    @Test("list allItemsPages yields page objects from live API")
    func listAllItemsPagesYieldsPageObjectsFromLiveAPI() async throws {
        let listID = 1 // A known public list
        var pageCount = 0
        for try await page in client.lists.allItemsPages(forList: listID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

}
