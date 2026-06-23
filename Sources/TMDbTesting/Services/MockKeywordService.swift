//
//  MockKeywordService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `KeywordService` for use in tests.
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
public final class MockKeywordService: KeywordService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Keyword, TMDbError> = .success(.sample)
        var moviesCalls: [MoviesCall] = []
        var moviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock keyword service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forKeyword:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `forKeyword` argument the method was called with.
        ///
        public let keywordID: Keyword.ID
    }

    ///
    /// The recorded calls to ``details(forKeyword:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forKeyword:)``.
    ///
    public var detailsResult: Result<Keyword, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter keywordID: The keyword identifier.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed keyword.
    ///
    public func details(forKeyword keywordID: Keyword.ID) async throws(TMDbError) -> Keyword {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(keywordID: keywordID))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - movies

    ///
    /// The arguments of a single call to ``movies(forKeyword:page:language:)``.
    ///
    public struct MoviesCall: Sendable {
        ///
        /// The `forKeyword` argument the method was called with.
        ///
        public let keywordID: Keyword.ID
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``movies(forKeyword:page:language:)``, in the order they were made.
    ///
    public var moviesCalls: [MoviesCall] {
        withLock { storage.moviesCalls }
    }

    ///
    /// The stubbed result returned by ``movies(forKeyword:page:language:)``.
    ///
    public var moviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.moviesResult } }
        set { withLock { storage.moviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``moviesResult``.
    ///
    /// - Parameters:
    ///   - keywordID: The keyword identifier.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func movies(
        forKeyword keywordID: Keyword.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.moviesCalls.append(
                MoviesCall(
                    keywordID: keywordID,
                    page: page,
                    language: language
                )
            )
            return storage.moviesResult
        }

        return try result.get()
    }

}
