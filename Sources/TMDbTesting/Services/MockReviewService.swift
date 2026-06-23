//
//  MockReviewService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `ReviewService` for use in tests.
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
public final class MockReviewService: ReviewService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Review, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock review service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forReview:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Review.ID
    }

    ///
    /// The recorded calls to ``details(forReview:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forReview:)``.
    ///
    public var detailsResult: Result<Review, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter id: The identifier of the review.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed review.
    ///
    public func details(forReview id: Review.ID) async throws(TMDbError) -> Review {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(id: id))
            return storage.detailsResult
        }

        return try result.get()
    }

}
