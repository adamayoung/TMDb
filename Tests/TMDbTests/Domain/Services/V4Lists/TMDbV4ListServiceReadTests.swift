//
//  TMDbV4ListServiceReadTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .list))
struct TMDbV4ListServiceReadTests {

    var service: TMDbV4ListService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbV4ListService(apiClient: apiClient)
    }

    private func sampleList(id: Int = 1) -> V4List {
        V4List(
            id: id,
            name: "My Watchlist",
            isPublic: true,
            createdBy: V4ListCreator(id: "abc", name: "Test", username: "test"),
            items: [],
            itemCount: 0,
            sortBy: "original_order.asc",
            languageCode: "en",
            countryCode: "US"
        )
    }

    // MARK: - details

    @Test("details returns the list and builds the expected request")
    func detailsReturnsList() async throws {
        let expectedResult = sampleList()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(forList: 1)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? V4ListRequest == V4ListRequest(id: 1))
    }

    @Test("details threads page, sort order, language and token into the request")
    func detailsBuildsFullRequest() async throws {
        apiClient.addResponse(.success(sampleList()))

        _ = try await service.details(
            forList: 1,
            page: 2,
            sortedBy: .title(descending: true),
            language: "en",
            accessToken: "user-token"
        )

        let expected = V4ListRequest(
            id: 1,
            page: 2,
            sortBy: .title(descending: true),
            language: "en",
            accessToken: "user-token"
        )
        #expect(apiClient.lastRequest as? V4ListRequest == expected)
    }

    @Test("details with an access token sends it as a bearer Authorization header")
    func detailsSendsAuthorizationHeader() async throws {
        apiClient.addResponse(.success(sampleList()))

        _ = try await service.details(forList: 1, accessToken: "user-token")

        let request = try #require(apiClient.lastRequest)
        #expect(request.headers["Authorization"] == "Bearer user-token")
    }

    @Test("details without an access token sends no Authorization header")
    func detailsWithoutTokenSendsNoAuthorizationHeader() async throws {
        apiClient.addResponse(.success(sampleList()))

        _ = try await service.details(forList: 1)

        let request = try #require(apiClient.lastRequest)
        #expect(request.headers["Authorization"] == nil)
    }

    @Test("details with an empty access token throws bad request without a call")
    func detailsWithEmptyTokenThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Access token must not be empty")
        )) {
            _ = try await service.details(
                forList: 1, page: nil, sortedBy: nil, language: nil, accessToken: " "
            )
        }

        #expect(apiClient.requests.isEmpty)
    }

    // MARK: - items

    @Test("items reshapes the list details into a pageable result")
    func itemsReshapesDetails() async throws {
        // v4 has no separate items endpoint — this is the same request.
        let list = V4List(
            id: 1,
            name: "My Watchlist",
            isPublic: true,
            createdBy: V4ListCreator(id: "abc", name: "Test", username: "test"),
            items: [],
            itemCount: 2,
            sortBy: "original_order.asc",
            languageCode: "en",
            countryCode: "US",
            page: 3,
            totalPages: 5,
            totalResults: 42
        )
        apiClient.addResponse(.success(list))

        let result = try await service.items(forList: 1)

        #expect(result.page == 3)
        #expect(result.totalPages == 5)
        #expect(result.totalResults == 42)
        #expect(apiClient.lastRequest as? V4ListRequest == V4ListRequest(id: 1))
    }

    // MARK: - itemStatus

    @Test("itemStatus is true when TMDb finds the item")
    func itemStatusTrueWhenPresent() async throws {
        apiClient.addResponse(.success(V4ListItemStatusResult(
            success: true, id: 1, mediaID: 550, mediaType: .movie
        )))

        let result = try await service.itemStatus(forMedia: 550, ofType: .movie, inList: 1)

        #expect(result)
        let expected = V4ListItemStatusRequest(listID: 1, mediaID: 550, mediaType: .movie)
        #expect(apiClient.lastRequest as? V4ListItemStatusRequest == expected)
    }

    @Test("itemStatus with an unknown media type throws bad request without a call")
    func itemStatusWithUnknownMediaTypeThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Media type must be a movie or a TV series")
        )) {
            _ = try await service.itemStatus(forMedia: 550, ofType: .unknown, inList: 1)
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("itemStatus is false when TMDb answers not found")
    func itemStatusFalseWhenNotFound() async throws {
        // TMDb has no present/absent flag — an absent item is a 404.
        apiClient.addResponse(.failure(.notFound(TMDbErrorContext())))

        let result = try await service.itemStatus(forMedia: 550, ofType: .movie, inList: 1)

        #expect(result == false)
    }

    @Test("itemStatus propagates errors other than not found")
    func itemStatusPropagatesOtherErrors() async throws {
        apiClient.addResponse(.failure(.unauthorised(TMDbErrorContext())))

        await #expect(throws: TMDbError.unauthorised(TMDbErrorContext())) {
            _ = try await service.itemStatus(forMedia: 550, ofType: .movie, inList: 1)
        }
    }

    @Test("itemStatus decodes the real item-status response")
    func itemStatusDecodesFixture() async throws {
        let response = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ListItemStatusResult.self, fromResource: "v4-list-item-status"
        )
        apiClient.addResponse(.success(response))

        let result = try await service.itemStatus(forMedia: 550, ofType: .movie, inList: 1)

        #expect(result)
        #expect(response.mediaID == 550)
        #expect(response.mediaType == .movie)
        #expect(response.id == 8_678_999)
    }

    @Test("itemStatus uses the tv media type for a TV series")
    func itemStatusUsesTVMediaType() async throws {
        apiClient.addResponse(.success(V4ListItemStatusResult(
            success: true, id: 1, mediaID: 1399, mediaType: .tvSeries
        )))

        _ = try await service.itemStatus(forMedia: 1399, ofType: .tvSeries, inList: 1)

        let request = try #require(apiClient.lastRequest)
        #expect(request.queryItems["media_type"] == "tv")
        #expect(request.queryItems["media_id"] == "1399")
    }

    // MARK: - lists

    @Test("lists returns the account's lists and builds the expected request")
    func listsReturnsAccountLists() async throws {
        let expectedResult = PageableListResult<V4ListSummary>(results: [])
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.lists(forAccount: "abc123", accessToken: "user-token")

        #expect(result == expectedResult)
        let expected = V4AccountListsRequest(accountObjectID: "abc123", accessToken: "user-token")
        #expect(apiClient.lastRequest as? V4AccountListsRequest == expected)
    }

    @Test("lists with an empty account object ID throws bad request without a call")
    func listsWithEmptyAccountIDThrows() async throws {
        await #expect(throws: TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Account object ID must not be empty")
        )) {
            _ = try await service.lists(forAccount: "", page: nil, accessToken: "user-token")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("lists percent-encodes the account object ID into the path")
    func listsEncodesAccountObjectID() async throws {
        apiClient.addResponse(.success(PageableListResult<V4ListSummary>(results: [])))

        _ = try await service.lists(forAccount: "a b/c", accessToken: "user-token")

        let request = try #require(apiClient.lastRequest)
        #expect(request.path == "/account/a%20b%2Fc/lists")
    }

}
