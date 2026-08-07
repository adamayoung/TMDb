//
//  MockV4ListService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length

import Foundation
import TMDb

///
/// A mock `V4ListService` for use in tests.
///
/// Each method records the calls it receives and returns an injectable stubbed
/// result. By default a freshly-constructed mock returns sample data, so it can
/// be used with zero setup; inject a `Result` into the matching `*Result`
/// property to control the outcome of a method — assert on the value you
/// injected, not on the believable defaults.
///
/// The mock is safe to share across concurrent calls: its recorded state is
/// guarded by a lock.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MockV4ListService: V4ListService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<V4List, TMDbError> = .success(.sample)
        var itemsCalls: [ItemsCall] = []
        var itemsResult: Result<PageableListResult<V4ListItem>, TMDbError> =
            .success(PageableListResult(results: V4ListItem.samples))
        var itemStatusCalls: [ItemStatusCall] = []
        var itemStatusResult: Result<Bool, TMDbError> = .success(true)
        var listsCalls: [ListsCall] = []
        var listsResult: Result<PageableListResult<V4ListSummary>, TMDbError> =
            .success(PageableListResult(results: V4ListSummary.samples))
        var createCalls: [CreateCall] = []
        var createResult: Result<V4CreateListResult, TMDbError> = .success(.sample)
        var updateCalls: [UpdateCall] = []
        var updateResult: Result<Void, TMDbError> = .success(())
        var addItemsCalls: [AddItemsCall] = []
        var addItemsResult: Result<V4ListItemsResult, TMDbError> = .success(.sample)
        var updateItemsCalls: [UpdateItemsCall] = []
        var updateItemsResult: Result<V4ListItemsResult, TMDbError> = .success(.sample)
        var removeItemsCalls: [RemoveItemsCall] = []
        var removeItemsResult: Result<V4ListItemsResult, TMDbError> = .success(.sample)
        var clearCalls: [ClearCall] = []
        var clearResult: Result<V4ClearListResult, TMDbError> = .success(.sample)
        var deleteCalls: [DeleteCall] = []
        var deleteResult: Result<Void, TMDbError> = .success(())
    }

    ///
    /// Creates a mock v4 list service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to
    /// ``details(forList:page:sortedBy:language:accessToken:)``.
    ///
    public struct DetailsCall: Sendable {

        /// The identifier of the list.
        public let listID: Int
        /// The requested page.
        public let page: Int?
        /// The requested sort order.
        public let sortedBy: V4ListSortBy?
        /// The requested language.
        public let language: String?
        /// The access token the method was called with.
        public let accessToken: String?

    }

    ///
    /// The recorded calls to ``details(forList:page:sortedBy:language:accessToken:)``,
    /// in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``details(forList:page:sortedBy:language:accessToken:)``.
    ///
    public var detailsResult: Result<V4List, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return.
    ///    - sortedBy: How to order the items.
    ///    - language: ISO 639-1 language code.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list.
    ///
    public func details(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> V4List {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(
                listID: listID,
                page: page,
                sortedBy: sortedBy,
                language: language,
                accessToken: accessToken
            ))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - items

    ///
    /// The arguments of a single call to
    /// ``items(forList:page:sortedBy:language:accessToken:)``.
    ///
    public struct ItemsCall: Sendable {

        /// The identifier of the list.
        public let listID: Int
        /// The requested page.
        public let page: Int?
        /// The requested sort order.
        public let sortedBy: V4ListSortBy?
        /// The requested language.
        public let language: String?
        /// The access token the method was called with.
        public let accessToken: String?

    }

    ///
    /// The recorded calls to ``items(forList:page:sortedBy:language:accessToken:)``,
    /// in the order they were made.
    ///
    public var itemsCalls: [ItemsCall] {
        withLock { storage.itemsCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``items(forList:page:sortedBy:language:accessToken:)``.
    ///
    public var itemsResult: Result<PageableListResult<V4ListItem>, TMDbError> {
        get { withLock { storage.itemsResult } }
        set { withLock { storage.itemsResult = newValue } }
    }

    ///
    /// Records the call and returns ``itemsResult``.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - page: The page of items to return.
    ///    - sortedBy: How to order the items.
    ///    - language: ISO 639-1 language code.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed page of items.
    ///
    public func items(
        forList listID: Int,
        page: Int?,
        sortedBy: V4ListSortBy?,
        language: String?,
        accessToken: String?
    ) async throws(TMDbError) -> PageableListResult<V4ListItem> {
        let result = withLock {
            storage.itemsCalls.append(ItemsCall(
                listID: listID,
                page: page,
                sortedBy: sortedBy,
                language: language,
                accessToken: accessToken
            ))
            return storage.itemsResult
        }

        return try result.get()
    }

    // MARK: - itemStatus

    ///
    /// The arguments of a single call to
    /// ``itemStatus(forMedia:ofType:inList:accessToken:)``.
    ///
    public struct ItemStatusCall: Sendable {

        /// The identifier of the movie or TV series.
        public let mediaID: Int
        /// Whether it is a movie or a TV series.
        public let showType: ShowType
        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String?

    }

    ///
    /// The recorded calls to ``itemStatus(forMedia:ofType:inList:accessToken:)``,
    /// in the order they were made.
    ///
    public var itemStatusCalls: [ItemStatusCall] {
        withLock { storage.itemStatusCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``itemStatus(forMedia:ofType:inList:accessToken:)``.
    ///
    public var itemStatusResult: Result<Bool, TMDbError> {
        get { withLock { storage.itemStatusResult } }
        set { withLock { storage.itemStatusResult = newValue } }
    }

    ///
    /// Records the call and returns ``itemStatusResult``.
    ///
    /// - Parameters:
    ///    - mediaID: The identifier of the movie or TV series.
    ///    - showType: Whether it is a movie or a TV series.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed status.
    ///
    public func itemStatus(
        forMedia mediaID: Int,
        ofType showType: ShowType,
        inList listID: Int,
        accessToken: String?
    ) async throws(TMDbError) -> Bool {
        let result = withLock {
            storage.itemStatusCalls.append(ItemStatusCall(
                mediaID: mediaID,
                showType: showType,
                listID: listID,
                accessToken: accessToken
            ))
            return storage.itemStatusResult
        }

        return try result.get()
    }

    // MARK: - lists

    ///
    /// The arguments of a single call to ``lists(forAccount:page:accessToken:)``.
    ///
    public struct ListsCall: Sendable {

        /// The account's object identifier.
        public let accountObjectID: String
        /// The requested page.
        public let page: Int?
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``lists(forAccount:page:accessToken:)``, in the
    /// order they were made.
    ///
    public var listsCalls: [ListsCall] {
        withLock { storage.listsCalls }
    }

    ///
    /// The stubbed result returned by ``lists(forAccount:page:accessToken:)``.
    ///
    public var listsResult: Result<PageableListResult<V4ListSummary>, TMDbError> {
        get { withLock { storage.listsResult } }
        set { withLock { storage.listsResult = newValue } }
    }

    ///
    /// Records the call and returns ``listsResult``.
    ///
    /// - Parameters:
    ///    - accountObjectID: The account's object identifier.
    ///    - page: The page of results to return.
    ///    - accessToken: The account owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed page of list summaries.
    ///
    public func lists(
        forAccount accountObjectID: String,
        page: Int?,
        accessToken: String
    ) async throws(TMDbError) -> PageableListResult<V4ListSummary> {
        let result = withLock {
            storage.listsCalls.append(ListsCall(
                accountObjectID: accountObjectID,
                page: page,
                accessToken: accessToken
            ))
            return storage.listsResult
        }

        return try result.get()
    }

    // MARK: - create

    ///
    /// The arguments of a single call to ``create(name:attributes:accessToken:)``.
    ///
    public struct CreateCall: Sendable {

        /// The list's name.
        public let name: String
        /// The list's other settable properties.
        public let attributes: V4ListAttributes?
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``create(name:attributes:accessToken:)``, in the
    /// order they were made.
    ///
    public var createCalls: [CreateCall] {
        withLock { storage.createCalls }
    }

    ///
    /// The stubbed result returned by ``create(name:attributes:accessToken:)``.
    ///
    public var createResult: Result<V4CreateListResult, TMDbError> {
        get { withLock { storage.createResult } }
        set { withLock { storage.createResult = newValue } }
    }

    ///
    /// Records the call and returns ``createResult``.
    ///
    /// - Parameters:
    ///    - name: The list's name.
    ///    - attributes: The list's other settable properties.
    ///    - accessToken: The user's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed create result.
    ///
    public func create(
        name: String,
        attributes: V4ListAttributes?,
        accessToken: String
    ) async throws(TMDbError) -> V4CreateListResult {
        let result = withLock {
            storage.createCalls.append(CreateCall(
                name: name,
                attributes: attributes,
                accessToken: accessToken
            ))
            return storage.createResult
        }

        return try result.get()
    }

    // MARK: - update

    ///
    /// The arguments of a single call to ``update(list:attributes:accessToken:)``.
    ///
    public struct UpdateCall: Sendable {

        /// The identifier of the list.
        public let listID: Int
        /// The properties to change.
        public let attributes: V4ListAttributes
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``update(list:attributes:accessToken:)``, in the
    /// order they were made.
    ///
    public var updateCalls: [UpdateCall] {
        withLock { storage.updateCalls }
    }

    ///
    /// The stubbed result returned by ``update(list:attributes:accessToken:)``.
    ///
    public var updateResult: Result<Void, TMDbError> {
        get { withLock { storage.updateResult } }
        set { withLock { storage.updateResult = newValue } }
    }

    ///
    /// Records the call and returns ``updateResult``.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - attributes: The properties to change.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func update(
        list listID: Int,
        attributes: V4ListAttributes,
        accessToken: String
    ) async throws(TMDbError) {
        let result = withLock {
            storage.updateCalls.append(UpdateCall(
                listID: listID,
                attributes: attributes,
                accessToken: accessToken
            ))
            return storage.updateResult
        }

        return try result.get()
    }

    // MARK: - addItems

    ///
    /// The arguments of a single call to ``addItems(_:toList:accessToken:)``.
    ///
    public struct AddItemsCall: Sendable {

        /// The items to add.
        public let items: [V4ListMediaItem]
        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``addItems(_:toList:accessToken:)``, in the order
    /// they were made.
    ///
    public var addItemsCalls: [AddItemsCall] {
        withLock { storage.addItemsCalls }
    }

    ///
    /// The stubbed result returned by ``addItems(_:toList:accessToken:)``.
    ///
    public var addItemsResult: Result<V4ListItemsResult, TMDbError> {
        get { withLock { storage.addItemsResult } }
        set { withLock { storage.addItemsResult = newValue } }
    }

    ///
    /// Records the call and returns ``addItemsResult``.
    ///
    /// - Parameters:
    ///    - items: The items to add.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed per-item outcomes.
    ///
    public func addItems(
        _ items: [V4ListMediaItem],
        toList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        let result = withLock {
            storage.addItemsCalls.append(AddItemsCall(
                items: items,
                listID: listID,
                accessToken: accessToken
            ))
            return storage.addItemsResult
        }

        return try result.get()
    }

    // MARK: - updateItems

    ///
    /// The arguments of a single call to ``updateItems(_:inList:accessToken:)``.
    ///
    public struct UpdateItemsCall: Sendable {

        /// The items to comment on.
        public let items: [V4ListItemComment]
        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``updateItems(_:inList:accessToken:)``, in the
    /// order they were made.
    ///
    public var updateItemsCalls: [UpdateItemsCall] {
        withLock { storage.updateItemsCalls }
    }

    ///
    /// The stubbed result returned by ``updateItems(_:inList:accessToken:)``.
    ///
    public var updateItemsResult: Result<V4ListItemsResult, TMDbError> {
        get { withLock { storage.updateItemsResult } }
        set { withLock { storage.updateItemsResult = newValue } }
    }

    ///
    /// Records the call and returns ``updateItemsResult``.
    ///
    /// - Parameters:
    ///    - items: The items to comment on.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed per-item outcomes.
    ///
    public func updateItems(
        _ items: [V4ListItemComment],
        inList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        let result = withLock {
            storage.updateItemsCalls.append(UpdateItemsCall(
                items: items,
                listID: listID,
                accessToken: accessToken
            ))
            return storage.updateItemsResult
        }

        return try result.get()
    }

    // MARK: - removeItems

    ///
    /// The arguments of a single call to ``removeItems(_:fromList:accessToken:)``.
    ///
    public struct RemoveItemsCall: Sendable {

        /// The items to remove.
        public let items: [V4ListMediaItem]
        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``removeItems(_:fromList:accessToken:)``, in the
    /// order they were made.
    ///
    public var removeItemsCalls: [RemoveItemsCall] {
        withLock { storage.removeItemsCalls }
    }

    ///
    /// The stubbed result returned by ``removeItems(_:fromList:accessToken:)``.
    ///
    public var removeItemsResult: Result<V4ListItemsResult, TMDbError> {
        get { withLock { storage.removeItemsResult } }
        set { withLock { storage.removeItemsResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeItemsResult``.
    ///
    /// - Parameters:
    ///    - items: The items to remove.
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed per-item outcomes.
    ///
    public func removeItems(
        _ items: [V4ListMediaItem],
        fromList listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ListItemsResult {
        let result = withLock {
            storage.removeItemsCalls.append(RemoveItemsCall(
                items: items,
                listID: listID,
                accessToken: accessToken
            ))
            return storage.removeItemsResult
        }

        return try result.get()
    }

    // MARK: - clear

    ///
    /// The arguments of a single call to ``clear(list:accessToken:)``.
    ///
    public struct ClearCall: Sendable {

        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``clear(list:accessToken:)``, in the order they
    /// were made.
    ///
    public var clearCalls: [ClearCall] {
        withLock { storage.clearCalls }
    }

    ///
    /// The stubbed result returned by ``clear(list:accessToken:)``.
    ///
    public var clearResult: Result<V4ClearListResult, TMDbError> {
        get { withLock { storage.clearResult } }
        set { withLock { storage.clearResult = newValue } }
    }

    ///
    /// Records the call and returns ``clearResult``.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed clear result.
    ///
    public func clear(
        list listID: Int,
        accessToken: String
    ) async throws(TMDbError) -> V4ClearListResult {
        let result = withLock {
            storage.clearCalls.append(ClearCall(listID: listID, accessToken: accessToken))
            return storage.clearResult
        }

        return try result.get()
    }

    // MARK: - delete

    ///
    /// The arguments of a single call to ``delete(list:accessToken:)``.
    ///
    public struct DeleteCall: Sendable {

        /// The identifier of the list.
        public let listID: Int
        /// The access token the method was called with.
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``delete(list:accessToken:)``, in the order they
    /// were made.
    ///
    public var deleteCalls: [DeleteCall] {
        withLock { storage.deleteCalls }
    }

    ///
    /// The stubbed result returned by ``delete(list:accessToken:)``.
    ///
    public var deleteResult: Result<Void, TMDbError> {
        get { withLock { storage.deleteResult } }
        set { withLock { storage.deleteResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteResult``.
    ///
    /// - Parameters:
    ///    - listID: The identifier of the list.
    ///    - accessToken: The list owner's access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func delete(list listID: Int, accessToken: String) async throws(TMDbError) {
        let result = withLock {
            storage.deleteCalls.append(DeleteCall(listID: listID, accessToken: accessToken))
            return storage.deleteResult
        }

        return try result.get()
    }

}

// swiftlint:enable file_length type_body_length
