//
//  TMDbV4ListService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbV4ListService: V4ListService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> V4List {
        try Self.validate(accessToken: accessToken)
        let request = V4ListRequest(
            id: listID,
            page: page,
            sortBy: sortedBy,
            language: language,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func items(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> PageableListResult<V4ListItem> {
        let list = try await details(
            forList: listID,
            page: page,
            sortedBy: sortedBy,
            language: language,
            accessToken: accessToken
        )

        return PageableListResult(
            page: list.page,
            results: list.items,
            totalResults: list.totalResults,
            totalPages: list.totalPages,
            droppedItemCount: list.droppedItemCount
        )
    }

    func itemStatus(
        forMedia mediaID: Int,
        ofType showType: ShowType,
        inList listID: Int,
        accessToken: String?
    ) async throws(TMDbError) -> Bool {
        try Self.validate(accessToken: accessToken)
        let request = V4ListItemStatusRequest(
            listID: listID,
            mediaID: mediaID,
            mediaType: showType,
            accessToken: accessToken
        )

        do {
            let result: V4ListItemStatusResult = try await apiClient.perform(request)
            return result.success
        } catch .notFound {
            // TMDb has no present/absent flag here: an item that is not in the
            // list, a list that does not exist, and a list you cannot see all
            // answer 404. Documented on the protocol.
            return false
        }
    }

    func lists(
        forAccount accountObjectID: String,
        page: Int?,
        accessToken: String
    ) async throws(TMDbError) -> PageableListResult<V4ListSummary> {
        try Self.validate(accessToken: accessToken)
        try Self.validate(accountObjectID: accountObjectID)
        let request = V4AccountListsRequest(
            accountObjectID: accountObjectID,
            page: page,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func create(
        name: String,
        attributes: V4ListAttributes?,
        accessToken: String
    ) async throws(TMDbError) -> V4CreateListResult {
        try Self.validate(accessToken: accessToken)
        try Self.validate(name: name)
        let request = CreateV4ListRequest(
            name: name,
            description: attributes?.description,
            isPublic: attributes?.isPublic,
            languageCode: attributes?.languageCode,
            countryCode: attributes?.countryCode,
            sortBy: attributes?.sortBy,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func update(
        list listID: Int,
        attributes: V4ListAttributes,
        accessToken: String
    ) async throws(TMDbError) {
        try Self.validate(accessToken: accessToken)
        if let name = attributes.name {
            try Self.validate(name: name)
        }
        let request = UpdateV4ListRequest(
            listID: listID,
            name: attributes.name,
            description: attributes.description,
            isPublic: attributes.isPublic,
            sortBy: attributes.sortBy,
            accessToken: accessToken
        )

        _ = try await apiClient.perform(request)
    }

    func addItems(
        _ items: [V4ListMediaItem],
        toList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        try Self.validate(accessToken: accessToken)
        try Self.validate(itemCount: items.count)
        let request = AddV4ListItemsRequest(
            items: items,
            listID: listID,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func updateItems(
        _ items: [V4ListItemComment],
        inList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        try Self.validate(accessToken: accessToken)
        try Self.validate(itemCount: items.count)
        let request = UpdateV4ListItemsRequest(
            items: items,
            listID: listID,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func removeItems(
        _ items: [V4ListMediaItem],
        fromList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        try Self.validate(accessToken: accessToken)
        try Self.validate(itemCount: items.count)
        let request = RemoveV4ListItemsRequest(
            items: items,
            listID: listID,
            accessToken: accessToken
        )

        return try await apiClient.perform(request)
    }

    func clear(
        list listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ClearListResult {
        try Self.validate(accessToken: accessToken)
        let request = ClearV4ListRequest(listID: listID, accessToken: accessToken)

        return try await apiClient.perform(request)
    }

    func delete(list listID: Int, accessToken: String) async throws(TMDbError) {
        try Self.validate(accessToken: accessToken)
        let request = DeleteV4ListRequest(listID: listID, accessToken: accessToken)

        _ = try await apiClient.perform(request)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbV4ListService {

    private static func validate(accessToken: String?) throws(TMDbError) {
        guard let accessToken else {
            return
        }

        try accessToken.validateNotEmpty(message: "Access token must not be empty")
    }

    private static func validate(name: String) throws(TMDbError) {
        try name.validateNotEmpty(message: "List name must not be empty")
    }

    private static func validate(accountObjectID: String) throws(TMDbError) {
        try accountObjectID.validateNotEmpty(message: "Account object ID must not be empty")
    }

    private static func validate(itemCount: Int) throws(TMDbError) {
        guard itemCount > 0 else {
            throw .badRequest(TMDbErrorContext(statusMessage: "Items must not be empty"))
        }
    }

}
