//
//  MockWatchProviderService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `WatchProviderService` for use in tests.
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
public final class MockWatchProviderService: WatchProviderService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var countriesCalls: [CountriesCall] = []
        var countriesResult: Result<[Country], TMDbError> = .success(.samples)
        var movieWatchProvidersCalls: [MovieWatchProvidersCall] = []
        var movieWatchProvidersResult: Result<[WatchProvider], TMDbError> = .success(.samples)
        var tvSeriesWatchProvidersCalls: [TVSeriesWatchProvidersCall] = []
        var tvSeriesWatchProvidersResult: Result<[WatchProvider], TMDbError> = .success(.samples)
    }

    ///
    /// Creates a mock watch provider service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - countries

    ///
    /// The arguments of a single call to ``countries(language:)``.
    ///
    public struct CountriesCall: Sendable {
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``countries(language:)``, in the order they were made.
    ///
    public var countriesCalls: [CountriesCall] {
        withLock { storage.countriesCalls }
    }

    ///
    /// The stubbed result returned by ``countries(language:)``.
    ///
    public var countriesResult: Result<[Country], TMDbError> {
        get { withLock { storage.countriesResult } }
        set { withLock { storage.countriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``countriesResult``.
    ///
    /// - Parameter language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of countries.
    ///
    public func countries(language: String?) async throws(TMDbError) -> [Country] {
        let result = withLock {
            storage.countriesCalls.append(CountriesCall(language: language))
            return storage.countriesResult
        }

        return try result.get()
    }

    // MARK: - movieWatchProviders

    ///
    /// The arguments of a single call to ``movieWatchProviders(filter:language:)``.
    ///
    public struct MovieWatchProvidersCall: Sendable {
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: WatchProviderFilter?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``movieWatchProviders(filter:language:)``, in the order they were
    /// made.
    ///
    public var movieWatchProvidersCalls: [MovieWatchProvidersCall] {
        withLock { storage.movieWatchProvidersCalls }
    }

    ///
    /// The stubbed result returned by ``movieWatchProviders(filter:language:)``.
    ///
    public var movieWatchProvidersResult: Result<[WatchProvider], TMDbError> {
        get { withLock { storage.movieWatchProvidersResult } }
        set { withLock { storage.movieWatchProvidersResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieWatchProvidersResult``.
    ///
    /// - Parameters:
    ///   - filter: Filter to narrow the watch providers returned.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of watch providers.
    ///
    public func movieWatchProviders(
        filter: WatchProviderFilter?,
        language: String?
    ) async throws(TMDbError) -> [WatchProvider] {
        let result = withLock {
            storage.movieWatchProvidersCalls.append(
                MovieWatchProvidersCall(filter: filter, language: language)
            )
            return storage.movieWatchProvidersResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesWatchProviders

    ///
    /// The arguments of a single call to ``tvSeriesWatchProviders(filter:language:)``.
    ///
    public struct TVSeriesWatchProvidersCall: Sendable {
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: WatchProviderFilter?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``tvSeriesWatchProviders(filter:language:)``, in the order they were
    /// made.
    ///
    public var tvSeriesWatchProvidersCalls: [TVSeriesWatchProvidersCall] {
        withLock { storage.tvSeriesWatchProvidersCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesWatchProviders(filter:language:)``.
    ///
    public var tvSeriesWatchProvidersResult: Result<[WatchProvider], TMDbError> {
        get { withLock { storage.tvSeriesWatchProvidersResult } }
        set { withLock { storage.tvSeriesWatchProvidersResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesWatchProvidersResult``.
    ///
    /// - Parameters:
    ///   - filter: Filter to narrow the watch providers returned.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of watch providers.
    ///
    public func tvSeriesWatchProviders(
        filter: WatchProviderFilter?,
        language: String?
    ) async throws(TMDbError) -> [WatchProvider] {
        let result = withLock {
            storage.tvSeriesWatchProvidersCalls.append(
                TVSeriesWatchProvidersCall(filter: filter, language: language)
            )
            return storage.tvSeriesWatchProvidersResult
        }

        return try result.get()
    }

}
