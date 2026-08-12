//
//  ListIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .integrationGate,
    .serialized,
    .tags(.list),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ListIntegrationTests {

    var listService: (any ListService)!

    init() {
        self.listService = CredentialHelper.shared.makeClient().lists
    }

    @Test("details")
    func details() async throws {
        let listID = 1

        let list = try await listService.details(forList: listID, page: nil)

        #expect(list.id == listID)
        #expect(list.name == "The Marvel Universe")
        #expect(list.description != nil)
        #expect(list.createdBy == "Travis Bell")
        #expect(list.iso6391 == "en")
        #expect(list.itemCount > 0)
    }

    @Test("items")
    func items() async throws {
        let listID = 1

        let result = try await listService.items(forList: listID, page: nil)

        #expect(!result.results.isEmpty)
        #expect(result.page >= 1)
        #expect(result.totalResults >= 1)
        #expect(result.totalPages >= 1)
        #expect(result.droppedItemCount == 0)
    }

    /// A v3 list holds movies and TV series together, and TMDb gives a TV row
    /// `name`/`original_name`/`first_air_date` with none of the movie keys. Both
    /// of these calls threw outright on any such list until `MediaListItem`
    /// learned the TV shape — and list 1, the one every other test here uses, is
    /// movie-only, so nothing caught it.
    ///
    /// This asserts *shape*, never content: list 8679585 is a third-party user
    /// list that can be edited or deleted at any time, and TMDb publishes no
    /// stable mixed-media list.
    @Test("details and items decode a list holding both movies and TV series")
    func mixedMediaListDecodes() async throws {
        let listID = 8_679_585

        let list = try await listService.details(forList: listID, page: nil)

        #expect(!list.items.isEmpty)
        #expect(list.droppedItemCount == 0)
        for item in list.items {
            #expect(!item.title.isEmpty)
        }

        let page = try await listService.items(forList: listID, page: nil)

        #expect(!page.results.isEmpty)
        #expect(page.droppedItemCount == 0)
        for item in page.results {
            #expect(!item.title.isEmpty)
        }
    }

    @Test("itemStatus")
    func itemStatus() async throws {
        let listID = 1
        let movieID = 550

        let status = try await listService.itemStatus(forMedia: movieID, inList: listID)

        #expect(status.id == String(listID))
        #expect(status.isPresent == false || status.isPresent == true)
    }

    @Test(
        "create list creates new list",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled("Requires authenticated session")
    )
    func createListCreatesNewList() async throws {
        let credential = CredentialHelper.shared.tmdbCredential
        let session = try await CredentialHelper.shared.makeClient()
            .authentication.createSession(withCredential: credential)

        let result = try await listService.create(
            name: "Test List",
            description: "Integration test list",
            language: "en",
            isPublic: false,
            session: session
        )

        #expect(result.listID > 0)
        #expect(result.success)
    }

    @Test(
        "add and remove item from list",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled("Requires authenticated session")
    )
    func addAndRemoveItemFromList() async throws {
        let credential = CredentialHelper.shared.tmdbCredential
        let session = try await CredentialHelper.shared.makeClient()
            .authentication.createSession(withCredential: credential)
        let listID = 1
        let movieID = 550

        try await listService.addItem(mediaID: movieID, toList: listID, session: session)

        let status = try await listService.itemStatus(forMedia: movieID, inList: listID)
        #expect(status.isPresent == true)

        try await listService.removeItem(mediaID: movieID, fromList: listID, session: session)
    }

    @Test(
        "clear list removes all items",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled("Requires authenticated session")
    )
    func clearListRemovesAllItems() async throws {
        let credential = CredentialHelper.shared.tmdbCredential
        let session = try await CredentialHelper.shared.makeClient()
            .authentication.createSession(withCredential: credential)
        let listID = 1

        try await listService.clear(list: listID, session: session)
    }

    @Test(
        "delete list removes list",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled("Requires authenticated session")
    )
    func deleteListRemovesList() async throws {
        let credential = CredentialHelper.shared.tmdbCredential
        let session = try await CredentialHelper.shared.makeClient()
            .authentication.createSession(withCredential: credential)
        let listID = 1

        try await listService.delete(list: listID, session: session)
    }

    @Test("create with empty name throws bad request")
    func createWithEmptyNameThrowsBadRequest() async throws {
        let session = Session(success: true, sessionID: "test-session")

        await #expect(throws: TMDbError.self) {
            _ = try await listService.create(
                name: "",
                description: nil,
                language: nil,
                isPublic: nil,
                session: session
            )
        }
    }

}
