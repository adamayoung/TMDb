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

    func details(forList listID: Int, page: Int? = nil) async throws -> MediaList {
        let request = ListRequest(id: listID, page: page)

        let list: MediaList
        do {
            list = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return list
    }

    func items(
        forList listID: Int,
        page: Int? = nil
    ) async throws -> PageableListResult<MediaListItem> {
        let request = ListRequest(id: listID, page: page)

        let response: MediaList
        do {
            response = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return PageableListResult(
            page: response.page,
            results: response.items,
            totalResults: response.totalResults,
            totalPages: response.totalPages
        )
    }

    func itemStatus(forMedia mediaID: Int, inList listID: Int) async throws
    -> MediaListItemStatus {
        let request = ListItemStatusRequest(listID: listID, mediaID: mediaID)

        let status: MediaListItemStatus
        do {
            status = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return status
    }

    func create(
        name: String,
        description: String? = nil,
        language: String? = nil,
        isPublic: Bool? = nil,
        session: Session
    ) async throws -> CreateListResult {
        let request = CreateListRequest(
            name: name,
            description: description,
            language: language,
            isPublic: isPublic,
            sessionID: session.sessionID
        )

        let result: CreateListResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result
    }

    func delete(list listID: Int, session: Session) async throws {
        let request = DeleteListRequest(listID: listID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func addItem(mediaID: Int, toList listID: Int, session: Session) async throws {
        let request = AddMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func removeItem(mediaID: Int, fromList listID: Int, session: Session) async throws {
        let request = RemoveMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func clear(list listID: Int, session: Session) async throws {
        let request = ClearListRequest(listID: listID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

}
