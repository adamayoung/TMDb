//
//  NetworkErrorRedactor.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

///
/// Redacts the caller's credentials from a transport error before it is wrapped
/// as the public ``TMDbError/network(_:)``.
///
/// A `URLSession` failure is an `NSError` whose `userInfo` carries the **whole**
/// URL of the request that failed, under `NSErrorFailingURLKey` and
/// `NSErrorFailingURLStringKey`. For a client created with
/// ``TMDbClient/init(apiKey:configuration:)`` that URL contains the `api_key`
/// query item, and a user-scoped v3 request adds `session_id` — so an ordinary
/// timeout or DNS failure would hand a credential to whatever the consumer logs
/// the error to. ``EndpointPathRedactor`` never covered this: it scrubs the
/// *path* of ``TMDbErrorContext/endpointPath``, and states in its own
/// documentation that the query string is out of its scope.
///
/// Two properties of the result are load-bearing, and both are chosen to be safe
/// rather than merely tidy:
///
/// - **An error needing no redaction is returned as the same instance.** A
///   consumer may supply their own `HTTPClient`, so the value being wrapped is
///   often their own error type. Rebuilding it as an `NSError` would erase that
///   type — `catch TMDbError.network(let error as MyTransportError)` would stop
///   matching — and degrade `localizedDescription` to Foundation's generic
///   "The operation couldn't be completed." Only a genuine redaction rebuilds.
/// - **A rebuilt error's `userInfo` is an allowlist, not a scrubbed copy.** A
///   real `URLSession` failure also carries `NSUnderlyingError` (an `NSError`
///   with a `userInfo` of its own) and `_NSURLErrorRelatedURLSessionTaskErrorKey`
///   (an array of tasks, each holding the original request). Walking every
///   value that *might* nest a URL is unbounded; copying forward only the keys
///   whose contents are known cannot leak by construction.
///
/// `domain` and `code` survive both paths — they are what callers branch on, and
/// they are the cross-platform property, since a `URLSession` error need not
/// bridge to `URLError` on swift-corelibs-foundation.
///
enum NetworkErrorRedactor {

    /// Replaces a credential value, and any token-bearing path identifier, in a
    /// redacted URL.
    ///
    /// Deliberately not ``EndpointPathRedactor``'s `{guest_session_id}` form:
    /// `{` and `}` are not legal in a URL path, and
    /// `URLComponents.percentEncodedPath`'s setter traps — rather than throws —
    /// on a value it considers badly encoded.
    static let placeholder = "REDACTED"

    /// Query items whose value is a credential.
    ///
    /// Compared lower-cased. These mirror ``APIRequestQueryItem/Name/apiKey``
    /// and ``APIRequestQueryItem/Name/sessionID``, the two credentials
    /// ``TMDbAPIClient`` can put in a URL; `request_token` and
    /// `guest_session_id` are included because TMDb accepts them as query items
    /// elsewhere and they are bearer-like in exactly the same way.
    private static let credentialQueryItemNames: Set<String> = [
        "api_key",
        "session_id",
        "request_token",
        "guest_session_id"
    ]

    /// The `userInfo` key holding the failing request's URL.
    private static let failingURLKey = NSURLErrorFailingURLErrorKey

    /// The `userInfo` key holding the failing request's URL as a string.
    ///
    /// Spelled as a literal because the Foundation constant for it,
    /// `NSURLErrorFailingURLStringErrorKey`, is deprecated from macOS 15.4 and
    /// this package builds warnings-as-errors — naming it fails the build. The
    /// literal is the key the runtime populates, on Darwin and on Linux.
    private static let failingURLStringKey = "NSErrorFailingURLStringKey"

    /// `userInfo` keys copied verbatim onto a rebuilt error.
    ///
    /// These hold human-readable text, never a URL, so a consumer's
    /// `localizedDescription` survives redaction unchanged.
    private static let preservedKeys = [
        NSLocalizedDescriptionKey,
        NSLocalizedFailureReasonErrorKey,
        NSLocalizedRecoverySuggestionErrorKey
    ]

    ///
    /// Returns `error` with any credential removed from the failing URL its
    /// `userInfo` carries.
    ///
    /// - Parameter error: The transport error about to be wrapped.
    ///
    /// - Returns: The same instance when nothing needed redacting; otherwise an
    ///   `NSError` with the same `domain` and `code` and a redacted `userInfo`.
    ///
    static func redact(_ error: Error) -> Error {
        let nsError = error as NSError
        let userInfo = nsError.userInfo
        guard !userInfo.isEmpty else {
            return error
        }

        let original = urlString(from: userInfo[failingURLKey])
        let originalString = urlString(from: userInfo[failingURLStringKey])

        let redacted = original.flatMap(redacting)
        let redactedString = originalString.flatMap(redacting)

        guard redacted != nil || redactedString != nil else {
            return error
        }

        var redactedUserInfo: [String: Any] = [:]
        for key in preservedKeys {
            if let value = userInfo[key] {
                redactedUserInfo[key] = value
            }
        }

        // A value that needed no redaction is carried over as it was; one that
        // cannot be rebuilt into a URL is dropped rather than passed through.
        if let value = redacted ?? original, let url = URL(string: value) {
            redactedUserInfo[failingURLKey] = url
        }

        if let value = redactedString ?? originalString {
            redactedUserInfo[failingURLStringKey] = value
        }

        return NSError(domain: nsError.domain, code: nsError.code, userInfo: redactedUserInfo)
    }

}

extension NetworkErrorRedactor {

    ///
    /// Reads a `userInfo` value that should hold a URL.
    ///
    /// Both the `URL`/`String` and the `NSURL`/`NSString` forms are accepted: a
    /// `URLSession` error stores the Objective-C types on Darwin, and a
    /// `String`-only cast would silently match nothing — a fail-*open* that no
    /// assertion about an absent credential could detect.
    ///
    private static func urlString(from value: Any?) -> String? {
        switch value {
        case let value as URL:
            value.absoluteString

        case let value as String:
            value

        case let value as NSURL:
            value.absoluteString

        default:
            (value as? NSString) as String?
        }
    }

    ///
    /// Returns the redacted form of a failing URL, or `nil` when it carries
    /// nothing that needs redacting.
    ///
    private static func redacting(_ value: String) -> String? {
        guard var components = URLComponents(string: value) else {
            // Foundation built this string from a URL of its own, so it should
            // always parse. That it did not means we cannot show it carries no
            // credential — fail closed rather than pass it through.
            return placeholder
        }

        var didRedact = false

        // `percentEncodedQueryItems`, never `queryItems`: the plain accessor
        // round-trips a literal `%2B` into `+`, so redacting the credential
        // would silently corrupt an unrelated `query=` beside it.
        if var queryItems = components.percentEncodedQueryItems {
            for index in queryItems.indices
                where credentialQueryItemNames.contains(queryItems[index].name.lowercased())
                && queryItems[index].value != nil {
                queryItems[index].value = placeholder
                didRedact = true
            }

            if didRedact {
                components.percentEncodedQueryItems = queryItems
            }
        }

        if let path = redactingPath(components.percentEncodedPath) {
            components.percentEncodedPath = path
            didRedact = true
        }

        guard didRedact else {
            return nil
        }

        return components.url?.absoluteString ?? placeholder
    }

    ///
    /// Returns the path with a token-bearing identifier segment replaced, or
    /// `nil` when it holds none.
    ///
    /// The failing URL is absolute, so its path begins with the API version
    /// (`/3` or `/4`) where ``EndpointPathRedactor`` expects the endpoint name.
    /// Handing it over unstripped makes the first segment `"3"`, the classifier
    /// match nothing, and the whole redaction a silent no-op that a test fed a
    /// bare path would never catch.
    ///
    private static func redactingPath(_ path: String) -> String? {
        var segments = path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)

        // The endpoint sits after the version prefix; without one, there is no
        // library-built path here to reason about.
        guard segments.count >= 3, EndpointPathRedactor.placeholder(forEndpoint: segments[1]) != nil
        else {
            return nil
        }

        segments[2] = placeholder

        return "/\(segments.joined(separator: "/"))"
    }

}
