//
//  MockGenreService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock ``GenreService`` for use in tests.
///
/// Each method records the calls it receives and returns an injectable stubbed
/// result. By default a freshly-constructed mock returns sample data, so it can
/// be used with zero setup; inject a ``Result`` into the matching `*Result`
/// property to control the outcome of a method — assert on the value you
/// injected, not on the believable defaults.
///
/// The mock is safe to share across concurrent calls: its recorded state is
/// guarded by a lock.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MockGenreService: GenreService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var movieGenresCalls: [MovieGenresCall] = []
        var movieGenresResult: Result<[Genre], TMDbError> = .success(.samples)
        var tvSeriesGenresCalls: [TVSeriesGenresCall] = []
        var tvSeriesGenresResult: Result<[Genre], TMDbError> = .success(.samples)
    }

    ///
    /// Creates a mock genre service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - movieGenres

    ///
    /// The arguments of a single call to ``movieGenres(language:)``.
    ///
    public struct MovieGenresCall: Sendable {
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``movieGenres(language:)``, in the order they were made.
    ///
    public var movieGenresCalls: [MovieGenresCall] {
        withLock { storage.movieGenresCalls }
    }

    ///
    /// The stubbed result returned by ``movieGenres(language:)``.
    ///
    public var movieGenresResult: Result<[Genre], TMDbError> {
        get { withLock { storage.movieGenresResult } }
        set { withLock { storage.movieGenresResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieGenresResult``.
    ///
    /// - Parameter language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The stubbed list of genres.
    ///
    public func movieGenres(language: String?) async throws(TMDbError) -> [Genre] {
        let result = withLock {
            storage.movieGenresCalls.append(MovieGenresCall(language: language))
            return storage.movieGenresResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesGenres

    ///
    /// The arguments of a single call to ``tvSeriesGenres(language:)``.
    ///
    public struct TVSeriesGenresCall: Sendable {
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``tvSeriesGenres(language:)``, in the order they were made.
    ///
    public var tvSeriesGenresCalls: [TVSeriesGenresCall] {
        withLock { storage.tvSeriesGenresCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesGenres(language:)``.
    ///
    public var tvSeriesGenresResult: Result<[Genre], TMDbError> {
        get { withLock { storage.tvSeriesGenresResult } }
        set { withLock { storage.tvSeriesGenresResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesGenresResult``.
    ///
    /// - Parameter language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The stubbed list of genres.
    ///
    public func tvSeriesGenres(language: String?) async throws(TMDbError) -> [Genre] {
        let result = withLock {
            storage.tvSeriesGenresCalls.append(TVSeriesGenresCall(language: language))
            return storage.tvSeriesGenresResult
        }

        return try result.get()
    }

}
