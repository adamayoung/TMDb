//
//  EndpointPathRedactor.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Redacts token-bearing segments from a request path so it is safe to surface in
/// a publicly-loggable ``TMDbErrorContext/endpointPath``.
///
/// TMDb embeds a guest session id or an account id directly in the URL path (for
/// example `/guest_session/{id}/rated/movies` or `/account/{id}/favorite`). The
/// guest session id is a bearer-like credential and the account id is personal
/// data, so both are replaced with a placeholder before the path leaves the
/// library. The API key and session id are query items, not path segments, and so
/// are never present in the value this type is given.
///
/// That is a statement about ``TMDbErrorContext/endpointPath``'s input, not about
/// the library as a whole: a `URLSession` failure carries the failing request's
/// **whole URL**, query string included, and ``NetworkErrorRedactor`` is what
/// covers that. The two share one classifier — ``placeholder(forEndpoint:)`` —
/// so a new token-in-path endpoint is learned by both from a single edit.
///
enum EndpointPathRedactor {

    ///
    /// Returns `path` with a leading `guest_session` or `account` identifier
    /// segment replaced by a placeholder; all other paths are returned unchanged.
    ///
    /// - Parameter path: The request path to redact.
    ///
    /// - Returns: The path with any token-bearing identifier segment redacted.
    ///
    static func redact(_ path: String) -> String {
        let hasLeadingSlash = path.hasPrefix("/")
        var segments = path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
        guard segments.count >= 2 else {
            return path
        }

        guard let placeholder = placeholder(forEndpoint: segments[0]) else {
            return path
        }

        segments[1] = placeholder
        let joined = segments.joined(separator: "/")

        return hasLeadingSlash ? "/\(joined)" : joined
    }

    ///
    /// The placeholder that replaces the identifier segment following `endpoint`,
    /// or `nil` when `endpoint` carries no token-bearing identifier.
    ///
    /// This is the single classifier for *which* endpoints put a credential or
    /// personal identifier in their path. ``NetworkErrorRedactor`` asks the same
    /// question of the failing URL in a transport error, and renders its own
    /// placeholder — one rule, two renderings — so a new token-in-path endpoint
    /// is learned by both from one edit here.
    ///
    /// - Parameter endpoint: The leading path segment naming the endpoint.
    ///
    /// - Returns: The placeholder for the following identifier segment, or `nil`.
    ///
    static func placeholder(forEndpoint endpoint: String) -> String? {
        switch endpoint {
        case "guest_session":
            "{guest_session_id}"

        case "account":
            "{account_id}"

        default:
            nil
        }
    }

}
