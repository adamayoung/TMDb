//
//  V4ListIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb

///
/// Live coverage of the v4 list lifecycle, against the real API.
///
/// The suite creates **one** list, exercises the whole lifecycle against it,
/// and deletes it. Two things learned the hard way while probing this API
/// shaped that:
///
/// - **TMDb rate-limits list creation.** Fourteen quick creates named
///   `probe <random>` were all rejected with `status_code` 18, "Content is
///   suspected to be spam". So this creates once per run, with a name a person
///   might plausibly use, and treats a spam rejection as a *skip* rather than a
///   failure — it says nothing about the library.
/// - **Cleanup cannot rely on a remembered identifier.** A probe script's
///   `EXIT` trap never fired and orphaned four lists on the account. Teardown
///   here enumerates the account's lists and deletes any left over from a
///   previous run, so an interrupted run self-heals on the next one.
///
@Suite(
    .integrationGate,
    .serialized,
    .tags(.list),
    .enabled(if: CredentialHelper.shared.hasAccessToken
        && CredentialHelper.shared.hasUserAccessToken)
)
final class V4ListIntegrationTests {

    private static let listName = "TMDb Swift integration"

    private let client: TMDbClient
    private let token: String
    private var listID: Int?

    init() {
        self.client = TMDbClient(
            bearerToken: CredentialHelper.shared.tmdbAccessToken,
            configuration: TMDbConfiguration(retry: .default)
        )
        self.token = CredentialHelper.shared.tmdbUserAccessToken
    }

    deinit {
        guard let listID else {
            return
        }
        let client = client
        let token = token
        Task {
            try? await client.v4Lists.delete(list: listID, accessToken: token)
        }
    }

    /// Creates the suite's list, or skips the test when TMDb's spam filter
    /// declines. Also clears anything a previous interrupted run left behind.
    private func makeList() async throws -> Int {
        try await deleteLeftoverLists()

        do {
            let result = try await client.v4Lists.create(
                name: Self.listName,
                attributes: V4ListAttributes(
                    description: "Created by the TMDb Swift package's integration tests",
                    isPublic: false,
                    languageCode: "en",
                    countryCode: "GB"
                ),
                accessToken: token
            )
            listID = result.id
            return result.id
        } catch let error {
            // TMDb rate-limits list creation and answers "Content is suspected
            // to be spam". This is deliberately NOT swallowed into a skip: a
            // green run that quietly created nothing would be indistinguishable
            // from one that worked. It fails, loudly, and the failure names
            // itself so `/fix-integration-failures` can tell an upstream limit
            // from real drift.
            Issue.record(
                error,
                """
                Creating the list failed. If the message is "Content is suspected to be spam", \
                this is TMDb rate-limiting list creation — an upstream limit, not a defect here. \
                Re-run after a pause.
                """
            )
            throw error
        }
    }

    private func deleteLeftoverLists() async throws {
        guard let accountObjectID = CredentialHelper.shared.v4AccountObjectID else {
            return
        }

        let lists = try await client.v4Lists.lists(
            forAccount: accountObjectID, accessToken: token
        )
        for list in lists.results where list.name == Self.listName {
            try? await client.v4Lists.delete(list: list.id, accessToken: token)
        }
    }

    @Test("the full list lifecycle: create, add, comment, read, remove, clear")
    func listLifecycle() async throws {
        let listID = try await makeList()

        // Create — a private list, which v3 lists cannot express.
        let created = try await client.v4Lists.details(forList: listID, accessToken: token)
        #expect(created.name == Self.listName)
        #expect(created.isPublic == false)
        #expect(created.items.isEmpty)

        // Add one movie and one TV series — the mixed list v4 exists for.
        let added = try await client.v4Lists.addItems(
            [.movie(550), .tvSeries(1399)], toList: listID, accessToken: token
        )
        #expect(added.allItemsSucceeded)

        let withItems = try await client.v4Lists.details(forList: listID, accessToken: token)
        #expect(withItems.items.count == withItems.itemCount)
        let movie = try #require(withItems.items.first { $0.id == 550 })
        let tvSeries = try #require(withItems.items.first { $0.id == 1399 })
        guard case .movie = movie.media, case .tvSeries = tvSeries.media else {
            Issue.record("expected one movie and one TV series in the list")
            return
        }

        // itemStatus, both ways round.
        let moviePresent = try await client.v4Lists.itemStatus(
            forMedia: 550, ofType: .movie, inList: listID, accessToken: token
        )
        #expect(moviePresent)
        let absent = try await client.v4Lists.itemStatus(
            forMedia: 680, ofType: .movie, inList: listID, accessToken: token
        )
        #expect(absent == false)

        // Comments only stick through updateItems, never through addItems.
        let commented = try await client.v4Lists.updateItems(
            [.movie(550, comment: "Integration test comment")],
            inList: listID,
            accessToken: token
        )
        #expect(commented.allItemsSucceeded)

        let withComment = try await client.v4Lists.details(forList: listID, accessToken: token)
        let commentedMovie = try #require(withComment.items.first { $0.id == 550 })
        #expect(commentedMovie.comment == "Integration test comment")

        // Remove one, then clear the rest.
        let removed = try await client.v4Lists.removeItems(
            [.movie(550)], fromList: listID, accessToken: token
        )
        #expect(removed.allItemsSucceeded)

        let cleared = try await client.v4Lists.clear(list: listID, accessToken: token)
        #expect(cleared.itemsDeleted >= 1)

        let empty = try await client.v4Lists.details(forList: listID, accessToken: token)
        #expect(empty.items.isEmpty)
    }

    @Test("removing an item that is not in the list reports a per-item failure")
    func removingAbsentItemReportsFailure() async throws {
        // Overall success with a failed item — the case that makes checking
        // `success` alone insufficient.
        let listID = try await makeList()

        let result = try await client.v4Lists.removeItems(
            [.movie(680)], fromList: listID, accessToken: token
        )

        #expect(result.success)
        #expect(result.allItemsSucceeded == false)
        #expect(result.failures.count == 1)
    }

    @Test("update renames a list and changes its sort order")
    func updateChangesListProperties() async throws {
        let listID = try await makeList()

        try await client.v4Lists.update(
            list: listID,
            attributes: V4ListAttributes(
                description: "Updated by the integration tests",
                sortBy: .title(descending: true)
            ),
            accessToken: token
        )

        let updated = try await client.v4Lists.details(forList: listID, accessToken: token)
        #expect(updated.description == "Updated by the integration tests")
        #expect(updated.sortBy == "title.desc")
    }

    @Test("the account lists endpoint returns the list, with its own wire types")
    func accountListsIncludesTheList() async throws {
        let listID = try await makeList()
        let accountObjectID = try #require(CredentialHelper.shared.v4AccountObjectID)

        let lists = try await client.v4Lists.lists(
            forAccount: accountObjectID, accessToken: token
        )

        let summary = try #require(lists.results.first { $0.id == listID })
        #expect(summary.name == Self.listName)
        // This endpoint sends `public` as 0/1 and `runtime` as a string; the
        // model maps both, so a decode regression shows up here.
        #expect(summary.isPublic == false)
        #expect(summary.runtime >= 0)
    }

    @Test("reading a public list needs no user token")
    func publicListReadableWithoutUserToken() async throws {
        // List 1 is a long-standing public TMDb list.
        let list = try await client.v4Lists.details(forList: 1)

        #expect(list.id == 1)
        #expect(list.isPublic)
    }

}
