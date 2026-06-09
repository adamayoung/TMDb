//
//  TMDbListService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbListService: ListService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forList listID: Int, page: Int? = nil) async throws(TMDbError) -> MediaList {
        let request = ListRequest(id: listID, page: page)

        return try await apiClient.perform(request)
    }

    func items(
        forList listID: Int,
        page: Int? = nil
    ) async throws(TMDbError) -> PageableListResult<MediaListItem> {
        let request = ListRequest(id: listID, page: page)

        let response: MediaList = try await apiClient.perform(request)

        return PageableListResult(
            page: response.page,
            results: response.items,
            totalResults: response.totalResults,
            totalPages: response.totalPages
        )
    }

    func itemStatus(forMedia mediaID: Int, inList listID: Int) async throws(TMDbError)
    -> MediaListItemStatus {
        let request = ListItemStatusRequest(listID: listID, mediaID: mediaID)

        return try await apiClient.perform(request)
    }

    func create(
        name: String,
        description: String? = nil,
        language: String? = nil,
        isPublic: Bool? = nil,
        session: Session
    ) async throws(TMDbError) -> CreateListResult {
        let request = CreateListRequest(
            name: name,
            description: description,
            language: language,
            isPublic: isPublic,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func delete(list listID: Int, session: Session) async throws(TMDbError) {
        let request = DeleteListRequest(listID: listID, sessionID: session.sessionID)

        _ = try await apiClient.perform(request)
    }

    func addItem(mediaID: Int, toList listID: Int, session: Session) async throws(TMDbError) {
        let request = AddMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

    func removeItem(mediaID: Int, fromList listID: Int, session: Session) async throws(TMDbError) {
        let request = RemoveMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

    func clear(list listID: Int, session: Session) async throws(TMDbError) {
        let request = ClearListRequest(listID: listID, sessionID: session.sessionID)

        _ = try await apiClient.perform(request)
    }

}
