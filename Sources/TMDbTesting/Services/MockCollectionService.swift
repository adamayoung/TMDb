//
//  MockCollectionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `CollectionService` for use in tests.
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
public final class MockCollectionService: CollectionService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Collection, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<CollectionImageCollection, TMDbError> = .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<[CollectionTranslation], TMDbError> = .success(.samples)
    }

    ///
    /// Creates a mock collection service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forCollection:language:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `collectionID` argument the method was called with.
        ///
        public let collectionID: Collection.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forCollection:language:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forCollection:language:)``.
    ///
    public var detailsResult: Result<Collection, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - collectionID: The identifier of the collection.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection.
    ///
    public func details(
        forCollection collectionID: Collection.ID,
        language: String?
    ) async throws(TMDbError) -> Collection {
        let result = withLock {
            storage.detailsCalls.append(
                DetailsCall(collectionID: collectionID, language: language)
            )
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forCollection:languages:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `collectionID` argument the method was called with.
        ///
        public let collectionID: Collection.ID
        ///
        /// The `languages` argument the method was called with.
        ///
        public let languages: [String]?
    }

    ///
    /// The recorded calls to ``images(forCollection:languages:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forCollection:languages:)``.
    ///
    public var imagesResult: Result<CollectionImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameters:
    ///   - collectionID: The identifier of the collection.
    ///   - languages: A list of ISO 639-1 language codes to filter images by.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection image collection.
    ///
    public func images(
        forCollection collectionID: Collection.ID,
        languages: [String]?
    ) async throws(TMDbError) -> CollectionImageCollection {
        let result = withLock {
            storage.imagesCalls.append(
                ImagesCall(collectionID: collectionID, languages: languages)
            )
            return storage.imagesResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to ``translations(forCollection:)``.
    ///
    public struct TranslationsCall: Sendable {
        ///
        /// The `collectionID` argument the method was called with.
        ///
        public let collectionID: Collection.ID
    }

    ///
    /// The recorded calls to ``translations(forCollection:)``, in the order they were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forCollection:)``.
    ///
    public var translationsResult: Result<[CollectionTranslation], TMDbError> {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Parameter collectionID: The identifier of the collection.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of collection translations.
    ///
    public func translations(forCollection collectionID: Collection.ID) async throws(TMDbError)
    -> [CollectionTranslation] {
        let result = withLock {
            storage.translationsCalls.append(TranslationsCall(collectionID: collectionID))
            return storage.translationsResult
        }

        return try result.get()
    }

}
