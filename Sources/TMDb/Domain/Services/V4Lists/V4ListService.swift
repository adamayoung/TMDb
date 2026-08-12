//
//  V4ListService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for managing TMDb v4 lists.
///
/// v4 lists differ from v3 lists in the ways that matter for a watchlist: they
/// hold **movies and TV series together**, they can be private, and each item
/// can carry a comment.
///
/// Reads take an optional `accessToken`. Passing `nil` authenticates with the
/// client's own credential, which is enough for a public list; a private list
/// needs its owner's access token, obtained through
/// ``V4AuthenticationService``. Writes always require one.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol V4ListService: Sendable {

    ///
    /// Returns the details of a list, including a page of its items.
    ///
    /// [TMDb API - List: Details](https://developer.themoviedb.org/v4/reference/list-details)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return.
    ///    - sortedBy: How to order the items for this request. Defaults to the
    ///      list's stored order.
    ///    - language: ISO 639-1 language code to display results in.
    ///    - accessToken: The list owner's access token. Required for a private
    ///      list; `nil` uses the client's credential.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching list.
    ///
    func details(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> V4List

    ///
    /// Returns a page of a list's items.
    ///
    /// This reshapes ``details(forList:page:sortedBy:language:accessToken:)`` —
    /// v4 has no separate items endpoint.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return.
    ///    - sortedBy: How to order the items for this request.
    ///    - language: ISO 639-1 language code to display results in.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of the list's items.
    ///
    func items(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> PageableListResult<V4ListItem>

    ///
    /// Checks whether a movie or TV series is in a list.
    ///
    /// [TMDb API - List: Item Status](https://developer.themoviedb.org/v4/reference/list-item-status)
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the movie or TV series.
    ///    - showType: Whether it is a movie or a TV series. ``ShowType/unknown``
    ///      is decode-only and throws ``TMDbError/badRequest(_:)``.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: `true` when the item is in the list.
    ///
    /// - Important: `false` means only "not found". TMDb answers 404 for an
    ///   item that is absent, for a list that does not exist, **and** for a
    ///   list you cannot see — the three are indistinguishable in its response.
    ///
    func itemStatus(
        forMedia mediaID: Int,
        ofType showType: ShowType,
        inList listID: Int,
        accessToken: String?
    ) async throws(TMDbError) -> Bool

    ///
    /// Returns the lists belonging to an account.
    ///
    /// [TMDb API - Account: Lists](https://developer.themoviedb.org/v4/reference/account-lists)
    ///
    /// - Parameters:
    ///    - accountObjectID: The account's object identifier, as returned by
    ///      ``V4AccessToken/accountID``.
    ///    - page: The page of results to return.
    ///    - accessToken: The account owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of the account's lists.
    ///
    func lists(
        forAccount accountObjectID: String,
        page: Int?,
        accessToken: String
    ) async throws(TMDbError) -> PageableListResult<V4ListSummary>

    ///
    /// Creates a list.
    ///
    /// [TMDb API - List: Create](https://developer.themoviedb.org/v4/reference/list-create)
    ///
    /// - Parameters:
    ///    - name: The list's name.
    ///    - attributes: The list's other settable properties. Any left `nil`
    ///      take TMDb's default; an omitted `isPublic` yields a public list.
    ///    - accessToken: The user's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The result, including the new list's identifier.
    ///
    func create(
        name: String,
        attributes: V4ListAttributes?,
        accessToken: String
    ) async throws(TMDbError) -> V4CreateListResult

    ///
    /// Updates a list's details.
    ///
    /// [TMDb API - List: Update](https://developer.themoviedb.org/v4/reference/list-update)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - attributes: The properties to change. Any left `nil` are unchanged.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func update(
        list listID: Int,
        attributes: V4ListAttributes,
        accessToken: String
    ) async throws(TMDbError)

    ///
    /// Adds items to a list.
    ///
    /// [TMDb API - List: Add Items](https://developer.themoviedb.org/v4/reference/list-add-items)
    ///
    /// - Parameters:
    ///    - items: The movies and TV series to add. An item whose media type is
    ///      ``ShowType/unknown`` throws ``TMDbError/badRequest(_:)``.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The per-item outcomes. Check these rather than the overall
    ///   success: TMDb reports success for a request in which individual items
    ///   failed.
    ///
    func addItems(
        _ items: [V4ListMediaItem],
        toList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult

    ///
    /// Sets comments on items already in a list.
    ///
    /// [TMDb API - List: Update Items](https://developer.themoviedb.org/v4/reference/list-update-items)
    ///
    /// - Parameters:
    ///    - items: The items to comment on. An item whose media type is
    ///      ``ShowType/unknown`` throws ``TMDbError/badRequest(_:)``.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The per-item outcomes.
    ///
    /// - Note: This is the only way to store a comment — adding an item with
    ///   one attached does not.
    ///
    func updateItems(
        _ items: [V4ListItemComment],
        inList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult

    ///
    /// Removes items from a list.
    ///
    /// [TMDb API - List: Remove Items](https://developer.themoviedb.org/v4/reference/list-remove-items)
    ///
    /// - Parameters:
    ///    - items: The movies and TV series to remove. An item whose media type
    ///      is ``ShowType/unknown`` throws ``TMDbError/badRequest(_:)``.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The per-item outcomes. Removing an item that is not in the
    ///   list reports overall success with that item marked failed.
    ///
    func removeItems(
        _ items: [V4ListMediaItem],
        fromList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult

    ///
    /// Removes every item from a list, keeping the list itself.
    ///
    /// [TMDb API - List: Clear](https://developer.themoviedb.org/v4/reference/list-clear)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The result, including how many items were removed.
    ///
    func clear(
        list listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ClearListResult

    ///
    /// Deletes a list.
    ///
    /// [TMDb API - List: Delete](https://developer.themoviedb.org/v4/reference/list-delete)
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func delete(list listID: Int, accessToken: String) async throws(TMDbError)

}
