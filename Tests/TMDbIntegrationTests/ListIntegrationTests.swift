//
//  ListIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.list),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ListIntegrationTests {

    var listService: (any ListService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.listService = TMDbClient(apiKey: apiKey).lists
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
        #expect(result.page != nil)
        #expect(result.totalResults != nil)
        #expect(result.totalPages != nil)
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
        let session = try await TMDbClient(
            apiKey: CredentialHelper.shared.tmdbAPIKey
        ).authentication.createSession(withCredential: credential)

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
        let session = try await TMDbClient(
            apiKey: CredentialHelper.shared.tmdbAPIKey
        ).authentication.createSession(withCredential: credential)
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
        let session = try await TMDbClient(
            apiKey: CredentialHelper.shared.tmdbAPIKey
        ).authentication.createSession(withCredential: credential)
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
        let session = try await TMDbClient(
            apiKey: CredentialHelper.shared.tmdbAPIKey
        ).authentication.createSession(withCredential: credential)
        let listID = 1

        try await listService.delete(list: listID, session: session)
    }

}
