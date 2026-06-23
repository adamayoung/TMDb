//
//  MockNetworkService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `NetworkService` for use in tests.
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
public final class MockNetworkService: NetworkService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Network, TMDbError> = .success(.sample)
        var alternativeNamesCalls: [AlternativeNamesCall] = []
        var alternativeNamesResult: Result<[NetworkAlternativeName], TMDbError> = .success(.samples)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<[NetworkLogo], TMDbError> = .success(.samples)
    }

    ///
    /// Creates a mock network service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forNetwork:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Network.ID
    }

    ///
    /// The recorded calls to ``details(forNetwork:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forNetwork:)``.
    ///
    public var detailsResult: Result<Network, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter id: The identifier of the network.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed network.
    ///
    public func details(forNetwork id: Network.ID) async throws(TMDbError) -> Network {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(id: id))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - alternativeNames

    ///
    /// The arguments of a single call to ``alternativeNames(forNetwork:)``.
    ///
    public struct AlternativeNamesCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Network.ID
    }

    ///
    /// The recorded calls to ``alternativeNames(forNetwork:)``, in the order they were made.
    ///
    public var alternativeNamesCalls: [AlternativeNamesCall] {
        withLock { storage.alternativeNamesCalls }
    }

    ///
    /// The stubbed result returned by ``alternativeNames(forNetwork:)``.
    ///
    public var alternativeNamesResult: Result<[NetworkAlternativeName], TMDbError> {
        get { withLock { storage.alternativeNamesResult } }
        set { withLock { storage.alternativeNamesResult = newValue } }
    }

    ///
    /// Records the call and returns ``alternativeNamesResult``.
    ///
    /// - Parameter id: The identifier of the network.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of alternative names.
    ///
    public func alternativeNames(
        forNetwork id: Network.ID
    ) async throws(TMDbError) -> [NetworkAlternativeName] {
        let result = withLock {
            storage.alternativeNamesCalls.append(AlternativeNamesCall(id: id))
            return storage.alternativeNamesResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forNetwork:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Network.ID
    }

    ///
    /// The recorded calls to ``images(forNetwork:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forNetwork:)``.
    ///
    public var imagesResult: Result<[NetworkLogo], TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameter id: The identifier of the network.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of network logos.
    ///
    public func images(forNetwork id: Network.ID) async throws(TMDbError) -> [NetworkLogo] {
        let result = withLock {
            storage.imagesCalls.append(ImagesCall(id: id))
            return storage.imagesResult
        }

        return try result.get()
    }

}
