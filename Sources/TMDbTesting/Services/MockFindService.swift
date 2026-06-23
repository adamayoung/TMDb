//
//  MockFindService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `FindService` for use in tests.
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
public final class MockFindService: FindService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var findCalls: [FindCall] = []
        var findResult: Result<FindResults, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock find service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - find

    ///
    /// The arguments of a single call to ``find(externalID:externalSource:language:)``.
    ///
    public struct FindCall: Sendable {
        ///
        /// The `externalID` argument the method was called with.
        ///
        public let externalID: String
        ///
        /// The `externalSource` argument the method was called with.
        ///
        public let externalSource: ExternalSource
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``find(externalID:externalSource:language:)``, in the order they
    /// were made.
    ///
    public var findCalls: [FindCall] {
        withLock { storage.findCalls }
    }

    ///
    /// The stubbed result returned by ``find(externalID:externalSource:language:)``.
    ///
    public var findResult: Result<FindResults, TMDbError> {
        get { withLock { storage.findResult } }
        set { withLock { storage.findResult = newValue } }
    }

    ///
    /// Records the call and returns ``findResult``.
    ///
    /// - Parameters:
    ///   - externalID: The external identifier to search for.
    ///   - externalSource: The source of the external identifier.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed find results.
    ///
    public func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String?
    ) async throws(TMDbError) -> FindResults {
        let result = withLock {
            storage.findCalls.append(
                FindCall(
                    externalID: externalID,
                    externalSource: externalSource,
                    language: language
                )
            )
            return storage.findResult
        }

        return try result.get()
    }

}
