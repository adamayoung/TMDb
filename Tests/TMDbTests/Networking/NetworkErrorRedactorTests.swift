//
//  NetworkErrorRedactorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct NetworkErrorRedactorTests {

    /// The literal, not `NSURLErrorFailingURLStringErrorKey`: that symbol is
    /// deprecated from macOS 15.4 and the package builds warnings-as-errors, so
    /// naming it fails the build. This is the key the runtime populates.
    static let failingURLStringKey = "NSErrorFailingURLStringKey"

    static func transportError(
        url urlString: String,
        code: Int = NSURLErrorTimedOut,
        extra: [String: Any] = [:]
    ) -> NSError {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Test URL is not parseable.")
        }

        var userInfo: [String: Any] = [
            NSURLErrorFailingURLErrorKey: url,
            failingURLStringKey: url.absoluteString,
            NSLocalizedDescriptionKey: "The request timed out."
        ]
        userInfo.merge(extra) { _, new in new }

        return NSError(domain: NSURLErrorDomain, code: code, userInfo: userInfo)
    }

    static func failingURLString(of error: Error) -> String? {
        (error as NSError).userInfo[failingURLStringKey] as? String
    }

    static func failingURL(of error: Error) -> URL? {
        (error as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL
    }

    @Test("redacts the api_key value in the URL-valued failing-URL entry")
    func redactsAPIKeyInURLValuedEntry() throws {
        let error = Self.transportError(url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret")

        let redacted = NetworkErrorRedactor.redact(error)

        let url = try #require(Self.failingURL(of: redacted))
        #expect(!url.absoluteString.contains("abc123secret"))
        #expect(url.absoluteString.contains("api_key=REDACTED"))
    }

    @Test("redacts the api_key value in the String-valued failing-URL entry")
    func redactsAPIKeyInStringValuedEntry() throws {
        let error = Self.transportError(url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret")

        let redacted = NetworkErrorRedactor.redact(error)

        let urlString = try #require(Self.failingURLString(of: redacted))
        #expect(!urlString.contains("abc123secret"))
        #expect(urlString.contains("api_key=REDACTED"))
    }

    @Test("redacts the session_id value")
    func redactsSessionID() throws {
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/account/12345/favorite?api_key=key&session_id=sess123secret"
        )

        let redacted = NetworkErrorRedactor.redact(error)

        let urlString = try #require(Self.failingURLString(of: redacted))
        #expect(!urlString.contains("sess123secret"))
        #expect(urlString.contains("session_id=REDACTED"))
    }

    @Test("redacts a guest session id path segment behind the version prefix")
    func redactsGuestSessionIDPathSegment() throws {
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/guest_session/gs123secret/rated/movies?api_key=key"
        )

        let redacted = NetworkErrorRedactor.redact(error)

        let urlString = try #require(Self.failingURLString(of: redacted))
        #expect(!urlString.contains("gs123secret"))
        #expect(urlString.contains("/3/guest_session/REDACTED/rated/movies"))
    }

    @Test("redacts an account id path segment behind the version prefix")
    func redactsAccountIDPathSegment() throws {
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/account/9876543/favorite?api_key=key"
        )

        let redacted = NetworkErrorRedactor.redact(error)

        let urlString = try #require(Self.failingURLString(of: redacted))
        #expect(!urlString.contains("9876543"))
        #expect(urlString.contains("/3/account/REDACTED/favorite"))
    }

    @Test("leaves a non-credential query item byte-identical, including a literal %2B")
    func leavesNonCredentialQueryItemsUntouched() throws {
        // `queryItems` — as opposed to `percentEncodedQueryItems` — decodes
        // `%2B` to `+` on the way back out, silently corrupting a search term
        // while redacting the credential beside it.
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/search/movie?api_key=abc123secret&query=Star%2BWars&language=en-GB"
        )

        let redacted = NetworkErrorRedactor.redact(error)

        let urlString = try #require(Self.failingURLString(of: redacted))
        #expect(urlString.contains("query=Star%2BWars"))
        #expect(urlString.contains("language=en-GB"))
    }

    @Test("keeps the localized description byte-identical")
    func keepsLocalizedDescription() {
        let error = Self.transportError(url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret")

        let redacted = NetworkErrorRedactor.redact(error)

        #expect((redacted as NSError).localizedDescription == error.localizedDescription)
        #expect((redacted as NSError).localizedDescription == "The request timed out.")
    }

    @Test("preserves the domain and code")
    func preservesDomainAndCode() {
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret",
            code: NSURLErrorNotConnectedToInternet
        )

        let redacted = NetworkErrorRedactor.redact(error) as NSError

        #expect(redacted.domain == NSURLErrorDomain)
        #expect(redacted.code == NSURLErrorNotConnectedToInternet)
    }

    @Test("drops a nested underlying error rather than trying to scrub it")
    func dropsNestedUnderlyingError() {
        // A real `URLSession` failure nests an `NSError` with a `userInfo` of
        // its own, and an array of `URLSessionTask`s each holding the original
        // request. Walking every value that might nest a URL is unbounded, so a
        // rebuilt error copies forward only the keys whose contents are known.
        let underlying = NSError(
            domain: "kCFErrorDomainCFNetwork",
            code: 1,
            userInfo: [Self.failingURLStringKey: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret"]
        )
        let error = Self.transportError(
            url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret",
            extra: [NSUnderlyingErrorKey: underlying]
        )

        let redacted = NetworkErrorRedactor.redact(error)

        #expect((redacted as NSError).userInfo[NSUnderlyingErrorKey] == nil)
        #expect(!String(describing: (redacted as NSError).userInfo).contains("abc123secret"))
    }

    @Test("returns the original instance when a custom error needs no redaction")
    func returnsOriginalInstanceForCustomError() {
        // A consumer may supply their own `HTTPClient`, so the value being
        // wrapped is often their own error type. Rebuilding it as an `NSError`
        // would erase that type and degrade its message.
        let error = StubTransportError.offline

        let redacted = NetworkErrorRedactor.redact(error)

        #expect(redacted as? StubTransportError == .offline)
        #expect(redacted.localizedDescription == "The stub transport is offline.")
    }

    @Test("returns the original error when its userInfo is empty")
    func returnsOriginalErrorWhenUserInfoIsEmpty() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)

        let redacted = NetworkErrorRedactor.redact(error) as NSError

        #expect(redacted === error)
    }

    @Test("reads an NSURL-valued entry as well as a URL-valued one")
    func readsNSURLValuedEntry() throws {
        // `URLSession` stores the Objective-C types on Darwin. A `URL`-only
        // cast that silently matched nothing would be a fail-open no assertion
        // about an absent credential could detect.
        let urlString = "https://api.themoviedb.org/3/movie/550?api_key=abc123secret"
        let nsURL = try #require(NSURL(string: urlString))
        let error = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorTimedOut,
            userInfo: [NSURLErrorFailingURLErrorKey: nsURL]
        )

        let redacted = NetworkErrorRedactor.redact(error)

        let url = try #require(Self.failingURL(of: redacted))
        #expect(!url.absoluteString.contains("abc123secret"))
    }

    @Test("leaves a credential-free failing URL untouched")
    func leavesCredentialFreeURLUntouched() {
        let error = Self.transportError(url: "https://api.themoviedb.org/3/movie/550?language=en-GB")

        let redacted = NetworkErrorRedactor.redact(error) as NSError

        #expect(redacted === error)
    }

    #if !canImport(FoundationNetworking)
        @Test("a redacted error still bridges to URLError")
        func redactedErrorStillBridgesToURLError() throws {
            // Darwin only: swift-corelibs-foundation hands back an `NSError` in
            // `NSURLErrorDomain` that need not bridge to `URLError` — which is
            // why `domain`/`code` preservation, asserted above, is the
            // cross-platform property. See `Error+Cancellation.swift`.
            let error = Self.transportError(url: "https://api.themoviedb.org/3/movie/550?api_key=abc123secret")

            let redacted = NetworkErrorRedactor.redact(error)

            let urlError = try #require(redacted as? URLError)
            #expect(urlError.code == .timedOut)
        }
    #endif

}

private enum StubTransportError: Error, LocalizedError, Equatable {

    case offline

    var errorDescription: String? {
        "The stub transport is offline."
    }

}
