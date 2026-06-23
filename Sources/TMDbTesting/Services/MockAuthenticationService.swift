//
//  MockAuthenticationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length
import Foundation
import TMDb

///
/// A mock `AuthenticationService` for use in tests.
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
public final class MockAuthenticationService: AuthenticationService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var guestSessionCalls: [GuestSessionCall] = []
        var guestSessionResult: Result<GuestSession, TMDbError> = .success(.sample)
        var requestTokenCalls: [RequestTokenCall] = []
        var requestTokenResult: Result<Token, TMDbError> = .success(.sample)
        var authenticateURLCalls: [AuthenticateURLCall] = []
        var authenticateURLResult =
            URL(string: "https://www.themoviedb.org/authenticate")
            ?? URL(fileURLWithPath: "/")
        var createSessionWithTokenCalls: [CreateSessionWithTokenCall] = []
        var createSessionWithTokenResult: Result<Session, TMDbError> = .success(.sample)
        var createSessionWithCredentialCalls: [CreateSessionWithCredentialCall] = []
        var createSessionWithCredentialResult: Result<Session, TMDbError> = .success(.sample)
        var createSessionWithV4AccessTokenCalls: [CreateSessionWithV4AccessTokenCall] = []
        var createSessionWithV4AccessTokenResult: Result<Session, TMDbError> = .success(.sample)
        var deleteSessionCalls: [DeleteSessionCall] = []
        var deleteSessionResult: Result<Bool, TMDbError> = .success(true)
        var validateKeyCalls: [ValidateKeyCall] = []
        var validateKeyResult: Result<Bool, TMDbError> = .success(true)
    }

    ///
    /// Creates a mock authentication service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - guestSession

    ///
    /// The arguments of a single call to ``guestSession()``.
    ///
    public struct GuestSessionCall: Sendable {}

    ///
    /// The recorded calls to ``guestSession()``, in the order they were made.
    ///
    public var guestSessionCalls: [GuestSessionCall] {
        withLock { storage.guestSessionCalls }
    }

    ///
    /// The stubbed result returned by ``guestSession()``.
    ///
    public var guestSessionResult: Result<GuestSession, TMDbError> {
        get { withLock { storage.guestSessionResult } }
        set { withLock { storage.guestSessionResult = newValue } }
    }

    ///
    /// Records the call and returns ``guestSessionResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed guest session.
    ///
    public func guestSession() async throws(TMDbError) -> GuestSession {
        let result = withLock {
            storage.guestSessionCalls.append(GuestSessionCall())
            return storage.guestSessionResult
        }

        return try result.get()
    }

    // MARK: - requestToken

    ///
    /// The arguments of a single call to ``requestToken()``.
    ///
    public struct RequestTokenCall: Sendable {}

    ///
    /// The recorded calls to ``requestToken()``, in the order they were made.
    ///
    public var requestTokenCalls: [RequestTokenCall] {
        withLock { storage.requestTokenCalls }
    }

    ///
    /// The stubbed result returned by ``requestToken()``.
    ///
    public var requestTokenResult: Result<Token, TMDbError> {
        get { withLock { storage.requestTokenResult } }
        set { withLock { storage.requestTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``requestTokenResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed request token.
    ///
    public func requestToken() async throws(TMDbError) -> Token {
        let result = withLock {
            storage.requestTokenCalls.append(RequestTokenCall())
            return storage.requestTokenResult
        }

        return try result.get()
    }

    // MARK: - authenticateURL

    ///
    /// The arguments of a single call to ``authenticateURL(for:redirectURL:)``.
    ///
    public struct AuthenticateURLCall: Sendable {
        ///
        /// The `token` argument the method was called with.
        ///
        public let token: Token
        ///
        /// The `redirectURL` argument the method was called with.
        ///
        public let redirectURL: URL?
    }

    ///
    /// The recorded calls to ``authenticateURL(for:redirectURL:)``, in the order they were made.
    ///
    public var authenticateURLCalls: [AuthenticateURLCall] {
        withLock { storage.authenticateURLCalls }
    }

    ///
    /// The stubbed URL returned by ``authenticateURL(for:redirectURL:)``.
    ///
    public var authenticateURLResult: URL {
        get { withLock { storage.authenticateURLResult } }
        set { withLock { storage.authenticateURLResult = newValue } }
    }

    ///
    /// Records the call and returns ``authenticateURLResult``.
    ///
    /// - Parameters:
    ///   - token: An intermediate request token.
    ///   - redirectURL: A URL to redirect to after authentication.
    ///
    /// - Returns: The stubbed authentication URL.
    ///
    public func authenticateURL(for token: Token, redirectURL: URL?) -> URL {
        withLock {
            storage.authenticateURLCalls.append(
                AuthenticateURLCall(token: token, redirectURL: redirectURL)
            )
            return storage.authenticateURLResult
        }
    }

    // MARK: - createSessionWithToken

    ///
    /// The arguments of a single call to ``createSession(withToken:)``.
    ///
    public struct CreateSessionWithTokenCall: Sendable {
        ///
        /// The `token` argument the method was called with.
        ///
        public let token: Token
    }

    ///
    /// The recorded calls to ``createSession(withToken:)``, in the order they were made.
    ///
    public var createSessionWithTokenCalls: [CreateSessionWithTokenCall] {
        withLock { storage.createSessionWithTokenCalls }
    }

    ///
    /// The stubbed result returned by ``createSession(withToken:)``.
    ///
    public var createSessionWithTokenResult: Result<Session, TMDbError> {
        get { withLock { storage.createSessionWithTokenResult } }
        set { withLock { storage.createSessionWithTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``createSessionWithTokenResult``.
    ///
    /// - Parameter token: An approved request token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed session.
    ///
    public func createSession(withToken token: Token) async throws(TMDbError) -> Session {
        let result = withLock {
            storage.createSessionWithTokenCalls.append(
                CreateSessionWithTokenCall(token: token)
            )
            return storage.createSessionWithTokenResult
        }

        return try result.get()
    }

    // MARK: - createSessionWithCredential

    ///
    /// The arguments of a single call to ``createSession(withCredential:)``.
    ///
    public struct CreateSessionWithCredentialCall: Sendable {
        ///
        /// The `credential` argument the method was called with.
        ///
        public let credential: Credential
    }

    ///
    /// The recorded calls to ``createSession(withCredential:)``, in the order they were made.
    ///
    public var createSessionWithCredentialCalls: [CreateSessionWithCredentialCall] {
        withLock { storage.createSessionWithCredentialCalls }
    }

    ///
    /// The stubbed result returned by ``createSession(withCredential:)``.
    ///
    public var createSessionWithCredentialResult: Result<Session, TMDbError> {
        get { withLock { storage.createSessionWithCredentialResult } }
        set { withLock { storage.createSessionWithCredentialResult = newValue } }
    }

    ///
    /// Records the call and returns ``createSessionWithCredentialResult``.
    ///
    /// - Parameter credential: A user's TMDb credential.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed session.
    ///
    public func createSession(
        withCredential credential: Credential
    ) async throws(TMDbError) -> Session {
        let result = withLock {
            storage.createSessionWithCredentialCalls.append(
                CreateSessionWithCredentialCall(credential: credential)
            )
            return storage.createSessionWithCredentialResult
        }

        return try result.get()
    }

    // MARK: - createSessionWithV4AccessToken

    ///
    /// The arguments of a single call to ``createSession(withV4AccessToken:)``.
    ///
    public struct CreateSessionWithV4AccessTokenCall: Sendable {
        ///
        /// The `v4AccessToken` argument the method was called with.
        ///
        public let v4AccessToken: String
    }

    ///
    /// The recorded calls to ``createSession(withV4AccessToken:)``, in the order they were made.
    ///
    public var createSessionWithV4AccessTokenCalls: [CreateSessionWithV4AccessTokenCall] {
        withLock { storage.createSessionWithV4AccessTokenCalls }
    }

    ///
    /// The stubbed result returned by ``createSession(withV4AccessToken:)``.
    ///
    public var createSessionWithV4AccessTokenResult: Result<Session, TMDbError> {
        get { withLock { storage.createSessionWithV4AccessTokenResult } }
        set { withLock { storage.createSessionWithV4AccessTokenResult = newValue } }
    }

    ///
    /// Records the call and returns ``createSessionWithV4AccessTokenResult``.
    ///
    /// - Parameter v4AccessToken: A TMDb v4 access token.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed session.
    ///
    public func createSession(
        withV4AccessToken v4AccessToken: String
    ) async throws(TMDbError) -> Session {
        let result = withLock {
            storage.createSessionWithV4AccessTokenCalls.append(
                CreateSessionWithV4AccessTokenCall(v4AccessToken: v4AccessToken)
            )
            return storage.createSessionWithV4AccessTokenResult
        }

        return try result.get()
    }

    // MARK: - deleteSession

    ///
    /// The arguments of a single call to ``deleteSession(_:)``.
    ///
    public struct DeleteSessionCall: Sendable {
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``deleteSession(_:)``, in the order they were made.
    ///
    public var deleteSessionCalls: [DeleteSessionCall] {
        withLock { storage.deleteSessionCalls }
    }

    ///
    /// The stubbed result returned by ``deleteSession(_:)``.
    ///
    public var deleteSessionResult: Result<Bool, TMDbError> {
        get { withLock { storage.deleteSessionResult } }
        set { withLock { storage.deleteSessionResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteSessionResult``.
    ///
    /// - Parameter session: The session to delete.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed deletion status.
    ///
    @discardableResult
    public func deleteSession(_ session: Session) async throws(TMDbError) -> Bool {
        let result = withLock {
            storage.deleteSessionCalls.append(DeleteSessionCall(session: session))
            return storage.deleteSessionResult
        }

        return try result.get()
    }

    // MARK: - validateKey

    ///
    /// The arguments of a single call to ``validateKey()``.
    ///
    public struct ValidateKeyCall: Sendable {}

    ///
    /// The recorded calls to ``validateKey()``, in the order they were made.
    ///
    public var validateKeyCalls: [ValidateKeyCall] {
        withLock { storage.validateKeyCalls }
    }

    ///
    /// The stubbed result returned by ``validateKey()``.
    ///
    public var validateKeyResult: Result<Bool, TMDbError> {
        get { withLock { storage.validateKeyResult } }
        set { withLock { storage.validateKeyResult = newValue } }
    }

    ///
    /// Records the call and returns ``validateKeyResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed validation status.
    ///
    public func validateKey() async throws(TMDbError) -> Bool {
        let result = withLock {
            storage.validateKeyCalls.append(ValidateKeyCall())
            return storage.validateKeyResult
        }

        return try result.get()
    }

}
