//
//  MockTVEpisodeGroupService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `TVEpisodeGroupService` for use in tests.
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
public final class MockTVEpisodeGroupService: TVEpisodeGroupService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<TVEpisodeGroup, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock TV episode group service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forTVEpisodeGroup:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: TVEpisodeGroup.ID
    }

    ///
    /// The recorded calls to ``details(forTVEpisodeGroup:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forTVEpisodeGroup:)``.
    ///
    public var detailsResult: Result<TVEpisodeGroup, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter id: The identifier of the TV episode group.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV episode group.
    ///
    public func details(
        forTVEpisodeGroup id: TVEpisodeGroup.ID
    ) async throws(TMDbError) -> TVEpisodeGroup {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(id: id))
            return storage.detailsResult
        }

        return try result.get()
    }

}
