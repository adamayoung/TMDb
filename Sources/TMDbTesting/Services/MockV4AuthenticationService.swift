//
//  MockV4AuthenticationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `V4AuthenticationService` for use in tests.
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
public final class MockV4AuthenticationService: V4AuthenticationService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var requestTokenCalls: [RequestTokenCall] = []
        var requestTokenResult: Result<V4RequestToken, TMDbError> = .success(.sample)
        var authenticateURLCalls: [AuthenticateURLCall] = []
        var authenticateURLResult =
            URL(string: "https://www.themoviedb.org/auth/access")
            ?? URL(fileURLWithPath: "/")
        var createAccessTokenCalls: [CreateAccessTokenCall] = []
        var createAccessTokenResult: Result<V4AccessToken, TMDbError> = .success(.sample)
        var deleteAccessTokenCalls: [DeleteAccessTokenCall] = []
        var deleteAccessTokenResult: Result<Bool, TMDbError> = .success(true)
    }

    ///
    /// Creates a mock v4 authentication service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - requestToken

    ///
    /// The arguments of a single call to ``requestToken(redirectURL:)``.
    ///
    public struct RequestTokenCall: Sendable {

        ///
        /// The URL to redirect to once the user has approved the request token.
        ///
        public let redirectURL: URL?

    }

    ///
    /// The recorded calls to ``requestToken(redirectURL:)``, in the order they were made.
    ///
    public var requestTokenCalls: [RequestTokenCall] {
        withLock { storage.requestTokenCalls }
    }

    ///
    /// The stubbed result returned by ``requestToken(redirectURL:)``.
    ///
    public var requestTokenResult: Result<V4RequestToken, TMDbError> {
        get { withLock { storage.requestTokenResult } }
        set { withLock { storage.requestTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``requestTokenResult``.
    ///
    /// - Parameter redirectURL: The URL to redirect to once the user has approved
    /// the request token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed request token.
    ///
    public func requestToken(redirectURL: URL?) async throws(TMDbError) -> V4RequestToken {
        let result = withLock {
            storage.requestTokenCalls.append(RequestTokenCall(redirectURL: redirectURL))
            return storage.requestTokenResult
        }

        return try result.get()
    }

    // MARK: - authenticateURL

    ///
    /// The arguments of a single call to ``authenticateURL(for:)``.
    ///
    public struct AuthenticateURLCall: Sendable {

        ///
        /// The request token the URL was built for.
        ///
        public let requestToken: V4RequestToken

    }

    ///
    /// The recorded calls to ``authenticateURL(for:)``, in the order they were made.
    ///
    public var authenticateURLCalls: [AuthenticateURLCall] {
        withLock { storage.authenticateURLCalls }
    }

    ///
    /// The stubbed URL returned by ``authenticateURL(for:)``.
    ///
    public var authenticateURLResult: URL {
        get { withLock { storage.authenticateURLResult } }
        set { withLock { storage.authenticateURLResult = newValue } }
    }

    ///
    /// Records the call and returns ``authenticateURLResult``.
    ///
    /// - Parameter requestToken: An intermediate request token.
    ///
    /// - Returns: The stubbed authenticate URL.
    ///
    public func authenticateURL(for requestToken: V4RequestToken) -> URL {
        withLock {
            storage.authenticateURLCalls.append(
                AuthenticateURLCall(requestToken: requestToken)
            )
            return storage.authenticateURLResult
        }
    }

    // MARK: - createAccessToken

    ///
    /// The arguments of a single call to ``createAccessToken(withRequestToken:)``.
    ///
    public struct CreateAccessTokenCall: Sendable {

        ///
        /// The user-approved request token being exchanged.
        ///
        public let requestToken: V4RequestToken

    }

    ///
    /// The recorded calls to ``createAccessToken(withRequestToken:)``, in the order
    /// they were made.
    ///
    public var createAccessTokenCalls: [CreateAccessTokenCall] {
        withLock { storage.createAccessTokenCalls }
    }

    ///
    /// The stubbed result returned by ``createAccessToken(withRequestToken:)``.
    ///
    public var createAccessTokenResult: Result<V4AccessToken, TMDbError> {
        get { withLock { storage.createAccessTokenResult } }
        set { withLock { storage.createAccessTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``createAccessTokenResult``.
    ///
    /// - Parameter requestToken: A user-approved request token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed access token.
    ///
    public func createAccessToken(
        withRequestToken requestToken: V4RequestToken
    ) async throws(TMDbError) -> V4AccessToken {
        let result = withLock {
            storage.createAccessTokenCalls.append(
                CreateAccessTokenCall(requestToken: requestToken)
            )
            return storage.createAccessTokenResult
        }

        return try result.get()
    }

    // MARK: - deleteAccessToken

    ///
    /// The arguments of a single call to ``deleteAccessToken(_:)``.
    ///
    public struct DeleteAccessTokenCall: Sendable {

        ///
        /// The access token that was revoked.
        ///
        public let accessToken: String

    }

    ///
    /// The recorded calls to ``deleteAccessToken(_:)``, in the order they were made.
    ///
    public var deleteAccessTokenCalls: [DeleteAccessTokenCall] {
        withLock { storage.deleteAccessTokenCalls }
    }

    ///
    /// The stubbed result returned by ``deleteAccessToken(_:)``.
    ///
    public var deleteAccessTokenResult: Result<Bool, TMDbError> {
        get { withLock { storage.deleteAccessTokenResult } }
        set { withLock { storage.deleteAccessTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteAccessTokenResult``.
    ///
    /// - Parameter accessToken: The access token to revoke.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed success flag.
    ///
    @discardableResult
    public func deleteAccessToken(_ accessToken: String) async throws(TMDbError) -> Bool {
        let result = withLock {
            storage.deleteAccessTokenCalls.append(
                DeleteAccessTokenCall(accessToken: accessToken)
            )
            return storage.deleteAccessTokenResult
        }

        return try result.get()
    }

}
