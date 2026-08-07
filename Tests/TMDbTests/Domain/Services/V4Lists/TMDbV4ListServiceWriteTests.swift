//
//  TMDbV4ListServiceWriteTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .list))
struct TMDbV4ListServiceWriteTests {

    var service: TMDbV4ListService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbV4ListService(apiClient: apiClient)
    }

    private static let token = "user-token"

    private func itemsResult() -> V4ListItemsResult {
        V4ListItemsResult(
            success: true,
            results: [V4ListItemResult(mediaType: .movie, mediaID: 550, success: true)]
        )
    }

    // MARK: - create

    @Test("create returns the new list identifier and builds the expected request")
    func createReturnsResult() async throws {
        let expectedResult = V4CreateListResult(success: true, id: 42)
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.create(name: "My Watchlist", accessToken: Self.token)

        #expect(result == expectedResult)
        let expected = CreateV4ListRequest(name: "My Watchlist", accessToken: Self.token)
        #expect(apiClient.lastRequest as? CreateV4ListRequest == expected)
    }

    @Test("create sends the visibility flag as an integer, not a boolean")
    func createSendsIntegerVisibility() async throws {
        // Established against the live API: {"public": false} is ignored and
        // the list comes back public, while {"public": 0} is honoured.
        apiClient.addResponse(.success(V4CreateListResult(success: true, id: 42)))

        _ = try await service.create(
            name: "My Watchlist",
            attributes: V4ListAttributes(isPublic: false),
            accessToken: Self.token
        )

        let request = try #require(apiClient.lastRequest as? CreateV4ListRequest)
        let body = try #require(request.body)
        #expect(body.isPublic == 0)

        // Asserted against the raw JSON text: `JSONSerialization` bridges 0 to
        // an NSNumber that casts happily to `false`, so a typed check here
        // could not tell the integer form from the boolean one — which is the
        // whole distinction that matters to TMDb.
        let data = try JSONEncoder.theMovieDatabaseV4.encode(body)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("\"public\":0"))
        #expect(json.contains("\"public\":false") == false)
    }

    @Test("create sends the sort order in TMDb's field.direction form")
    func createSendsSortBy() async throws {
        apiClient.addResponse(.success(V4CreateListResult(success: true, id: 42)))

        _ = try await service.create(
            name: "My Watchlist",
            attributes: V4ListAttributes(
                description: "Films",
                isPublic: true,
                languageCode: "en",
                countryCode: "US",
                sortBy: .title(descending: true)
            ),
            accessToken: Self.token
        )

        let request = try #require(apiClient.lastRequest as? CreateV4ListRequest)
        let body = try #require(request.body)
        #expect(body.sortBy == "title.desc")
        #expect(body.languageCode == "en")
        #expect(body.countryCode == "US")
        #expect(body.isPublic == 1)
    }

    @Test("create with an empty name throws bad request without a call")
    func createWithEmptyNameThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "List name must not be empty")
        )) {
            _ = try await service.create(name: " ", accessToken: Self.token)
        }

        #expect(apiClient.requests.isEmpty)
    }

    // MARK: - update

    @Test("update builds a PUT request")
    func updateBuildsPutRequest() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))

        try await service.update(list: 1, name: "Renamed", accessToken: Self.token)

        let request = try #require(apiClient.lastRequest)
        #expect(request.method == .put)
        #expect(request.path == "/list/1")
    }

    @Test("update with an empty name throws bad request without a call")
    func updateWithEmptyNameThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "List name must not be empty")
        )) {
            try await service.update(
                list: 1,
                attributes: V4ListAttributes(name: " "),
                accessToken: Self.token
            )
        }

        #expect(apiClient.requests.isEmpty)
    }

    // MARK: - addItems

    @Test("addItems posts the items and returns the per-item outcomes")
    func addItemsReturnsResult() async throws {
        let expectedResult = itemsResult()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.addItems(
            [.movie(550), .tvSeries(1399)], toList: 1, accessToken: Self.token
        )

        #expect(result == expectedResult)
        let request = try #require(apiClient.lastRequest)
        #expect(request.method == .post)
        #expect(request.path == "/list/1/items")
    }

    @Test("addItems with no items throws bad request without a call")
    func addItemsWithNoItemsThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Items must not be empty")
        )) {
            _ = try await service.addItems([], toList: 1, accessToken: Self.token)
        }

        #expect(apiClient.requests.isEmpty)
    }

    // MARK: - updateItems

    @Test("updateItems builds a PUT — the only way a comment is stored")
    func updateItemsBuildsPutRequest() async throws {
        apiClient.addResponse(.success(itemsResult()))

        _ = try await service.updateItems(
            [.movie(550, comment: "Great twist")], inList: 1, accessToken: Self.token
        )

        let request = try #require(apiClient.lastRequest)
        #expect(request.method == .put)
        #expect(request.path == "/list/1/items")
    }

    // MARK: - removeItems

    @Test("removeItems builds a DELETE carrying a body")
    func removeItemsBuildsDeleteRequest() async throws {
        apiClient.addResponse(.success(itemsResult()))

        _ = try await service.removeItems([.movie(550)], fromList: 1, accessToken: Self.token)

        let request = try #require(apiClient.lastRequest as? RemoveV4ListItemsRequest)
        #expect(request.method == .delete)
        #expect(request.path == "/list/1/items")
        #expect(request.body?.items == [.movie(550)])
    }

    @Test("removeItems surfaces a per-item failure alongside overall success")
    func removeItemsSurfacesPartialFailure() async throws {
        apiClient.addResponse(.success(V4ListItemsResult(
            success: true,
            results: [V4ListItemResult(mediaType: .movie, mediaID: 550, success: false)]
        )))

        let result = try await service.removeItems(
            [.movie(550)], fromList: 1, accessToken: Self.token
        )

        #expect(result.success)
        #expect(result.allItemsSucceeded == false)
        #expect(result.failures.count == 1)
    }

    // MARK: - clear

    @Test("clear is a GET that reports how many items went")
    func clearIsAGet() async throws {
        // A state-changing GET: POST to this path returns 404.
        apiClient.addResponse(.success(V4ClearListResult(success: true, id: 1, itemsDeleted: 2)))

        let result = try await service.clear(list: 1, accessToken: Self.token)

        #expect(result.itemsDeleted == 2)
        let request = try #require(apiClient.lastRequest)
        #expect(request.method == .get)
        #expect(request.path == "/list/1/clear")
    }

    // MARK: - delete

    @Test("delete builds a DELETE request")
    func deleteBuildsDeleteRequest() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))

        try await service.delete(list: 1, accessToken: Self.token)

        let request = try #require(apiClient.lastRequest)
        #expect(request.method == .delete)
        #expect(request.path == "/list/1")
    }

    @Test("every write sends the access token as a bearer Authorization header")
    func writesSendAuthorizationHeader() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))

        try await service.delete(list: 1, accessToken: Self.token)

        let request = try #require(apiClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer user-token")
    }

    @Test("a write with an empty access token throws bad request without a call")
    func writeWithEmptyTokenThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Access token must not be empty")
        )) {
            try await service.delete(list: 1, accessToken: " ")
        }

        #expect(apiClient.requests.isEmpty)
    }

}
