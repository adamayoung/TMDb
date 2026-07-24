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
/// are never present here.
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

        let placeholder: String? = switch segments[0] {
        case "guest_session":
            "{guest_session_id}"

        case "account":
            "{account_id}"

        default:
            nil
        }

        guard let placeholder else {
            return path
        }

        segments[1] = placeholder
        let joined = segments.joined(separator: "/")

        return hasLeadingSlash ? "/\(joined)" : joined
    }

}
