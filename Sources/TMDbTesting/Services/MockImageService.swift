//
//  MockImageService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `ImageService` that records calls and returns injected results.
///
/// The URL-generating methods are protocol-extension methods over
/// `imagesConfiguration()`, so stubbing `imagesConfigurationResult` transitively
/// controls every URL this service produces.
///
/// - Note: Unstubbed methods return sample data, so assert on values you have
///   stubbed rather than on the defaults.
///
/// The mock is safe to share across concurrent calls: its recorded state is
/// guarded by a lock.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MockImageService: ImageService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var imagesConfigurationCalls: [ImagesConfigurationCall] = []
        var imagesConfigurationResult: Result<ImagesConfiguration, TMDbError> = .success(.sample)
        var refreshCalls: [RefreshCall] = []
        var refreshResult: Result<ImagesConfiguration, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock image service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }

        return body()
    }

    // MARK: - imagesConfiguration

    ///
    /// The arguments of a single call to ``imagesConfiguration()``.
    ///
    public struct ImagesConfigurationCall: Sendable {}

    ///
    /// The recorded calls to ``imagesConfiguration()``, in the order they were made.
    ///
    public var imagesConfigurationCalls: [ImagesConfigurationCall] {
        withLock { storage.imagesConfigurationCalls }
    }

    ///
    /// The stubbed result returned by ``imagesConfiguration()``.
    ///
    public var imagesConfigurationResult: Result<ImagesConfiguration, TMDbError> {
        get { withLock { storage.imagesConfigurationResult } }
        set { withLock { storage.imagesConfigurationResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesConfigurationResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed images configuration.
    ///
    public func imagesConfiguration() async throws(TMDbError) -> ImagesConfiguration {
        let result = withLock {
            storage.imagesConfigurationCalls.append(ImagesConfigurationCall())

            return storage.imagesConfigurationResult
        }

        return try result.get()
    }

    // MARK: - refresh

    ///
    /// The arguments of a single call to ``refresh()``.
    ///
    public struct RefreshCall: Sendable {}

    ///
    /// The recorded calls to ``refresh()``, in the order they were made.
    ///
    public var refreshCalls: [RefreshCall] {
        withLock { storage.refreshCalls }
    }

    ///
    /// The stubbed result returned by ``refresh()``.
    ///
    public var refreshResult: Result<ImagesConfiguration, TMDbError> {
        get { withLock { storage.refreshResult } }
        set { withLock { storage.refreshResult = newValue } }
    }

    ///
    /// Records the call and returns ``refreshResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed images configuration.
    ///
    @discardableResult
    public func refresh() async throws(TMDbError) -> ImagesConfiguration {
        let result = withLock {
            storage.refreshCalls.append(RefreshCall())

            return storage.refreshResult
        }

        return try result.get()
    }

}
