//
//  MockCertificationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `CertificationService` for use in tests.
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
public final class MockCertificationService: CertificationService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var movieCertificationsCalls: [MovieCertificationsCall] = []
        var movieCertificationsResult: Result<[String: [Certification]], TMDbError> =
            .success(["US": .samples])
        var tvSeriesCertificationsCalls: [TVSeriesCertificationsCall] = []
        var tvSeriesCertificationsResult: Result<[String: [Certification]], TMDbError> =
            .success(["US": .samples])
    }

    ///
    /// Creates a mock certification service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - movieCertifications

    ///
    /// The arguments of a single call to ``movieCertifications()``.
    ///
    public struct MovieCertificationsCall: Sendable {}

    ///
    /// The recorded calls to ``movieCertifications()``, in the order they were made.
    ///
    public var movieCertificationsCalls: [MovieCertificationsCall] {
        withLock { storage.movieCertificationsCalls }
    }

    ///
    /// The stubbed result returned by ``movieCertifications()``.
    ///
    public var movieCertificationsResult: Result<[String: [Certification]], TMDbError> {
        get { withLock { storage.movieCertificationsResult } }
        set { withLock { storage.movieCertificationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieCertificationsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed movie certifications, keyed by country code.
    ///
    public func movieCertifications() async throws(TMDbError) -> [String: [Certification]] {
        let result = withLock {
            storage.movieCertificationsCalls.append(MovieCertificationsCall())
            return storage.movieCertificationsResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesCertifications

    ///
    /// The arguments of a single call to ``tvSeriesCertifications()``.
    ///
    public struct TVSeriesCertificationsCall: Sendable {}

    ///
    /// The recorded calls to ``tvSeriesCertifications()``, in the order they were made.
    ///
    public var tvSeriesCertificationsCalls: [TVSeriesCertificationsCall] {
        withLock { storage.tvSeriesCertificationsCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesCertifications()``.
    ///
    public var tvSeriesCertificationsResult: Result<[String: [Certification]], TMDbError> {
        get { withLock { storage.tvSeriesCertificationsResult } }
        set { withLock { storage.tvSeriesCertificationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesCertificationsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV series certifications, keyed by country code.
    ///
    public func tvSeriesCertifications() async throws(TMDbError) -> [String: [Certification]] {
        let result = withLock {
            storage.tvSeriesCertificationsCalls.append(TVSeriesCertificationsCall())
            return storage.tvSeriesCertificationsResult
        }

        return try result.get()
    }

}
