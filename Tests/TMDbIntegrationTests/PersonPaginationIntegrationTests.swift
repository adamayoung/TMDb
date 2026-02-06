//
//  PersonPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.person),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct PersonPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("person allPopular fetches items from live API")
    func personAllPopularFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.people.allPopular() {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("person allPopularPages yields page objects from live API")
    func personAllPopularPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.people.allPopularPages() {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("person allTaggedImages fetches items from live API")
    func personAllTaggedImagesFetchesItemsFromLiveAPI() async throws {
        let personID = 287 // Brad Pitt - has tagged images
        var itemCount = 0
        for try await _ in client.people.allTaggedImages(forPerson: personID) {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("person allTaggedImagesPages yields page objects from live API")
    func personAllTaggedImagesPagesYieldsPageObjectsFromLiveAPI() async throws {
        let personID = 287 // Brad Pitt
        var pageCount = 0
        for try await page in client.people.allTaggedImagesPages(forPerson: personID) {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

}
