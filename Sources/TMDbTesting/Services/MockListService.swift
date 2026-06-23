//
//  MockListService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length
import Foundation
import TMDb

///
/// A mock `ListService` for use in tests.
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
public final class MockListService: ListService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<MediaList, TMDbError> = .success(.sample)
        var itemsCalls: [ItemsCall] = []
        var itemsResult: Result<PageableListResult<MediaListItem>, TMDbError> = .success(.sample)
        var itemStatusCalls: [ItemStatusCall] = []
        var itemStatusResult: Result<MediaListItemStatus, TMDbError> = .success(.sample)
        var createCalls: [CreateCall] = []
        var createResult: Result<CreateListResult, TMDbError> = .success(.sample)
        var deleteCalls: [DeleteCall] = []
        var deleteResult: Result<Void, TMDbError> = .success(())
        var addItemCalls: [AddItemCall] = []
        var addItemResult: Result<Void, TMDbError> = .success(())
        var removeItemCalls: [RemoveItemCall] = []
        var removeItemResult: Result<Void, TMDbError> = .success(())
        var clearCalls: [ClearCall] = []
        var clearResult: Result<Void, TMDbError> = .success(())
    }

    ///
    /// Creates a mock list service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forList:page:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``details(forList:page:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forList:page:)``.
    ///
    public var detailsResult: Result<MediaList, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - listID: The identifier of the list.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed media list.
    ///
    public func details(forList listID: Int, page: Int?) async throws(TMDbError) -> MediaList {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(listID: listID, page: page))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - items

    ///
    /// The arguments of a single call to ``items(forList:page:)``.
    ///
    public struct ItemsCall: Sendable {
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``items(forList:page:)``, in the order they were made.
    ///
    public var itemsCalls: [ItemsCall] {
        withLock { storage.itemsCalls }
    }

    ///
    /// The stubbed result returned by ``items(forList:page:)``.
    ///
    public var itemsResult: Result<PageableListResult<MediaListItem>, TMDbError> {
        get { withLock { storage.itemsResult } }
        set { withLock { storage.itemsResult = newValue } }
    }

    ///
    /// Records the call and returns ``itemsResult``.
    ///
    /// - Parameters:
    ///   - listID: The identifier of the list.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of media items.
    ///
    public func items(
        forList listID: Int,
        page: Int?
    ) async throws(TMDbError) -> PageableListResult<MediaListItem> {
        let result = withLock {
            storage.itemsCalls.append(ItemsCall(listID: listID, page: page))
            return storage.itemsResult
        }

        return try result.get()
    }

    // MARK: - itemStatus

    ///
    /// The arguments of a single call to ``itemStatus(forMedia:inList:)``.
    ///
    public struct ItemStatusCall: Sendable {
        ///
        /// The `mediaID` argument the method was called with.
        ///
        public let mediaID: Int
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
    }

    ///
    /// The recorded calls to ``itemStatus(forMedia:inList:)``, in the order they were made.
    ///
    public var itemStatusCalls: [ItemStatusCall] {
        withLock { storage.itemStatusCalls }
    }

    ///
    /// The stubbed result returned by ``itemStatus(forMedia:inList:)``.
    ///
    public var itemStatusResult: Result<MediaListItemStatus, TMDbError> {
        get { withLock { storage.itemStatusResult } }
        set { withLock { storage.itemStatusResult = newValue } }
    }

    ///
    /// Records the call and returns ``itemStatusResult``.
    ///
    /// - Parameters:
    ///   - mediaID: The identifier of the media.
    ///   - listID: The identifier of the list.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed media list item status.
    ///
    public func itemStatus(
        forMedia mediaID: Int,
        inList listID: Int
    ) async throws(TMDbError) -> MediaListItemStatus {
        let result = withLock {
            storage.itemStatusCalls.append(ItemStatusCall(mediaID: mediaID, listID: listID))
            return storage.itemStatusResult
        }

        return try result.get()
    }

    // MARK: - create

    ///
    /// The arguments of a single call to ``create(name:description:language:isPublic:session:)``.
    ///
    public struct CreateCall: Sendable {
        ///
        /// The `name` argument the method was called with.
        ///
        public let name: String
        ///
        /// The `description` argument the method was called with.
        ///
        public let description: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
        ///
        /// The `isPublic` argument the method was called with.
        ///
        public let isPublic: Bool?
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``create(name:description:language:isPublic:session:)``, in the
    /// order they were made.
    ///
    public var createCalls: [CreateCall] {
        withLock { storage.createCalls }
    }

    ///
    /// The stubbed result returned by ``create(name:description:language:isPublic:session:)``.
    ///
    public var createResult: Result<CreateListResult, TMDbError> {
        get { withLock { storage.createResult } }
        set { withLock { storage.createResult = newValue } }
    }

    ///
    /// Records the call and returns ``createResult``.
    ///
    /// - Parameters:
    ///   - name: The name of the list.
    ///   - description: The description of the list.
    ///   - language: ISO 639-1 language code for the list.
    ///   - isPublic: Whether the list is public.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed create list result.
    ///
    public func create(
        name: String,
        description: String?,
        language: String?,
        isPublic: Bool?,
        session: Session
    ) async throws(TMDbError) -> CreateListResult {
        let result = withLock {
            storage.createCalls.append(
                CreateCall(
                    name: name,
                    description: description,
                    language: language,
                    isPublic: isPublic,
                    session: session
                )
            )
            return storage.createResult
        }

        return try result.get()
    }

    // MARK: - delete

    ///
    /// The arguments of a single call to ``delete(list:session:)``.
    ///
    public struct DeleteCall: Sendable {
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``delete(list:session:)``, in the order they were made.
    ///
    public var deleteCalls: [DeleteCall] {
        withLock { storage.deleteCalls }
    }

    ///
    /// The stubbed result returned by ``delete(list:session:)``.
    ///
    public var deleteResult: Result<Void, TMDbError> {
        get { withLock { storage.deleteResult } }
        set { withLock { storage.deleteResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteResult``.
    ///
    /// - Parameters:
    ///   - listID: The identifier of the list.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func delete(list listID: Int, session: Session) async throws(TMDbError) {
        let result = withLock {
            storage.deleteCalls.append(DeleteCall(listID: listID, session: session))
            return storage.deleteResult
        }

        return try result.get()
    }

    // MARK: - addItem

    ///
    /// The arguments of a single call to ``addItem(mediaID:toList:session:)``.
    ///
    public struct AddItemCall: Sendable {
        ///
        /// The `mediaID` argument the method was called with.
        ///
        public let mediaID: Int
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``addItem(mediaID:toList:session:)``, in the order they were made.
    ///
    public var addItemCalls: [AddItemCall] {
        withLock { storage.addItemCalls }
    }

    ///
    /// The stubbed result returned by ``addItem(mediaID:toList:session:)``.
    ///
    public var addItemResult: Result<Void, TMDbError> {
        get { withLock { storage.addItemResult } }
        set { withLock { storage.addItemResult = newValue } }
    }

    ///
    /// Records the call and returns ``addItemResult``.
    ///
    /// - Parameters:
    ///   - mediaID: The identifier of the media.
    ///   - listID: The identifier of the list.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addItem(mediaID: Int, toList listID: Int, session: Session) async throws(TMDbError) {
        let result = withLock {
            storage.addItemCalls.append(
                AddItemCall(mediaID: mediaID, listID: listID, session: session)
            )
            return storage.addItemResult
        }

        return try result.get()
    }

    // MARK: - removeItem

    ///
    /// The arguments of a single call to ``removeItem(mediaID:fromList:session:)``.
    ///
    public struct RemoveItemCall: Sendable {
        ///
        /// The `mediaID` argument the method was called with.
        ///
        public let mediaID: Int
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``removeItem(mediaID:fromList:session:)``, in the order they were
    /// made.
    ///
    public var removeItemCalls: [RemoveItemCall] {
        withLock { storage.removeItemCalls }
    }

    ///
    /// The stubbed result returned by ``removeItem(mediaID:fromList:session:)``.
    ///
    public var removeItemResult: Result<Void, TMDbError> {
        get { withLock { storage.removeItemResult } }
        set { withLock { storage.removeItemResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeItemResult``.
    ///
    /// - Parameters:
    ///   - mediaID: The identifier of the media.
    ///   - listID: The identifier of the list.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func removeItem(
        mediaID: Int,
        fromList listID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.removeItemCalls.append(
                RemoveItemCall(mediaID: mediaID, listID: listID, session: session)
            )
            return storage.removeItemResult
        }

        return try result.get()
    }

    // MARK: - clear

    ///
    /// The arguments of a single call to ``clear(list:session:)``.
    ///
    public struct ClearCall: Sendable {
        ///
        /// The `listID` argument the method was called with.
        ///
        public let listID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``clear(list:session:)``, in the order they were made.
    ///
    public var clearCalls: [ClearCall] {
        withLock { storage.clearCalls }
    }

    ///
    /// The stubbed result returned by ``clear(list:session:)``.
    ///
    public var clearResult: Result<Void, TMDbError> {
        get { withLock { storage.clearResult } }
        set { withLock { storage.clearResult = newValue } }
    }

    ///
    /// Records the call and returns ``clearResult``.
    ///
    /// - Parameters:
    ///   - listID: The identifier of the list.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func clear(list listID: Int, session: Session) async throws(TMDbError) {
        let result = withLock {
            storage.clearCalls.append(ClearCall(listID: listID, session: session))
            return storage.clearResult
        }

        return try result.get()
    }

}
