//
//  ListService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for managing user lists from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ListService: Sendable {

    ///
    /// Returns the details of a list.
    ///
    /// [TMDb API - Lists: Details](https://developer.themoviedb.org/reference/list-details)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return. Defaults to `1`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching list details.
    ///
    func details(forList listID: Int, page: Int?) async throws -> MediaList

    ///
    /// Returns the items in a list.
    ///
    /// [TMDb API - Lists: Details](https://developer.themoviedb.org/reference/list-details)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return. Defaults to `1`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of media items.
    ///
    func items(
        forList listID: Int,
        page: Int?
    ) async throws -> PageableListResult<MediaListItem>

    ///
    /// Checks whether an item is present in a list.
    ///
    /// [TMDb API - Lists: Check Item Status](https://developer.themoviedb.org/reference/list-check-item-status)
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the media item to check.
    ///    - listID: The identifier of the list.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The item status in the list.
    ///
    func itemStatus(forMedia mediaID: Int, inList listID: Int) async throws -> MediaListItemStatus

    ///
    /// Creates a new list.
    ///
    /// [TMDb API - Lists: Create List](https://developer.themoviedb.org/reference/list-create)
    ///
    /// - Parameters:
    ///    - name: The name of the list.
    ///    - description: The description of the list.
    ///    - language: ISO 639-1 language code. Defaults to the client's configured default language.
    ///    - isPublic: Whether the list is public. Defaults to `true`.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The result of the create operation including the new list ID.
    ///
    func create(
        name: String,
        description: String?,
        language: String?,
        isPublic: Bool?,
        session: Session
    ) async throws -> CreateListResult

    ///
    /// Deletes a list.
    ///
    /// [TMDb API - Lists: Delete List](https://developer.themoviedb.org/reference/list-delete)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list to delete.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func delete(list listID: Int, session: Session) async throws

    ///
    /// Adds an item to a list.
    ///
    /// [TMDb API - Lists: Add Item](https://developer.themoviedb.org/reference/list-add-item)
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the media item to add.
    ///    - listID: The identifier of the list.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addItem(mediaID: Int, toList listID: Int, session: Session) async throws

    ///
    /// Removes an item from a list.
    ///
    /// [TMDb API - Lists: Remove Item](https://developer.themoviedb.org/reference/list-remove-item)
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the media item to remove.
    ///    - listID: The identifier of the list.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeItem(mediaID: Int, fromList listID: Int, session: Session) async throws

    ///
    /// Clears all items from a list.
    ///
    /// [TMDb API - Lists: Clear List](https://developer.themoviedb.org/reference/list-clear)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list to clear.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func clear(list listID: Int, session: Session) async throws

}
