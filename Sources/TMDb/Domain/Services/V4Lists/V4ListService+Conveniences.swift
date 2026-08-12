//
//  V4ListService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Shorter forms of the ``V4ListService`` requirements.
///
/// Every one of these **drops** parameters rather than defaulting them. A
/// defaulted overload would share its requirement's signature — default values
/// are not part of a signature for witness matching — and so would silently
/// become that requirement's default implementation, recursing forever for any
/// conformer that omitted it. `Scripts/check-defaulted-witnesses.py` fails the
/// lint if one is ever added here.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension V4ListService {

    ///
    /// Returns the details of a public list.
    ///
    /// - Parameter listID: The identifier of the list.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching list.
    ///
    func details(forList listID: Int) async throws(TMDbError) -> V4List {
        try await details(
            forList: listID, page: nil, sortedBy: nil, language: nil, accessToken: nil
        )
    }

    ///
    /// Returns the details of a list, as its owner.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching list.
    ///
    func details(
        forList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4List {
        try await details(
            forList: listID, page: nil, sortedBy: nil, language: nil, accessToken: accessToken
        )
    }

    ///
    /// Returns a page of a public list's items.
    ///
    /// - Parameter listID: The identifier of the list.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of the list's items.
    ///
    func items(forList listID: Int) async throws(TMDbError) -> PageableListResult<V4ListItem> {
        try await items(
            forList: listID, page: nil, sortedBy: nil, language: nil, accessToken: nil
        )
    }

    ///
    /// Returns a page of a list's items, as its owner.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of the list's items.
    ///
    func items(
        forList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> PageableListResult<V4ListItem> {
        try await items(
            forList: listID, page: nil, sortedBy: nil, language: nil, accessToken: accessToken
        )
    }

    ///
    /// Checks whether a movie or TV series is in a public list.
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the movie or TV series.
    ///    - showType: Whether it is a movie or a TV series. ``ShowType/unknown``
    ///      is decode-only and throws ``TMDbError/badRequest(_:)``.
    ///    - listID: The identifier of the list.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: `true` when the item is in the list.
    ///
    func itemStatus(
        forMedia mediaID: Int,
        ofType showType: ShowType,
        inList listID: Int
    ) async throws(TMDbError) -> Bool {
        try await itemStatus(
            forMedia: mediaID, ofType: showType, inList: listID, accessToken: nil
        )
    }

    ///
    /// Returns the lists belonging to an account.
    ///
    /// - Parameters:
    ///    - accountObjectID: The account's object identifier.
    ///    - accessToken: The account owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable list of the account's lists.
    ///
    func lists(
        forAccount accountObjectID: String,
        accessToken: String
    ) async throws(TMDbError) -> PageableListResult<V4ListSummary> {
        try await lists(forAccount: accountObjectID, page: nil, accessToken: accessToken)
    }

    ///
    /// Creates a list with just a name.
    ///
    /// - Parameters:
    ///    - name: The list's name.
    ///    - accessToken: The user's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The result, including the new list's identifier.
    ///
    func create(
        name: String,
        accessToken: String
    ) async throws(TMDbError) -> V4CreateListResult {
        try await create(name: name, attributes: nil, accessToken: accessToken)
    }

    ///
    /// Renames a list.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - name: The new name.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func update(
        list listID: Int,
        name: String,
        accessToken: String
    ) async throws(TMDbError) {
        try await update(
            list: listID,
            attributes: V4ListAttributes(name: name),
            accessToken: accessToken
        )
    }

}
