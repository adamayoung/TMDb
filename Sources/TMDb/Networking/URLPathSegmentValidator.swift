//
//  URLPathSegmentValidator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Decides whether a request path is safe to send, by checking that no segment
/// can break out of itself once the server percent-decodes it.
///
/// Percent-encoding a caller-supplied identifier (ADR-0008) is not on its own a
/// defence against path traversal: TMDb's edge percent-decodes the path *and
/// then* resolves
/// `..`, so `/3/credit/x%2F..%2F..%2Fmovie%2F550` reaches the `movie` endpoint
/// exactly as the unencoded form does — carrying the caller's `api_key`. The
/// encoding is undone by the peer, so the only reliable defence is to refuse to
/// send such a request at all.
///
/// A segment is rejected when, after a single percent-decode, it is a
/// dot-segment, contains a separator, still contains a `%`, or contains a
/// control character.
///
/// TMDb's own identifiers are unaffected: credit, review, episode-group and
/// account-object ids are drawn from the RFC 3986 *unreserved* set, so they
/// decode to themselves. The one caller-supplied value not under TMDb's control
/// is `FindByIDRequest`'s external id, which carries third-party identifiers
/// (IMDb, Wikidata, and social handles) — a handle containing a separator would
/// be refused here rather than sent, which is the intended trade.
///
enum URLPathSegmentValidator {

    ///
    /// Returns whether every segment of a percent-encoded path stays inert once
    /// percent-decoded.
    ///
    /// - Parameter percentEncodedPath: The percent-encoded request path to check.
    ///
    /// - Returns: `true` when the path is safe to send; `false` when any segment
    ///   could resolve to a different endpoint.
    ///
    static func isSafe(path percentEncodedPath: String) -> Bool {
        percentEncodedPath
            .split(separator: "/", omittingEmptySubsequences: true)
            .allSatisfy { isSafeSegment(String($0)) }
    }

    private static func isSafeSegment(_ percentEncodedSegment: String) -> Bool {
        // Fail closed. A segment this library cannot decode is one whose meaning
        // to the peer is unknown, and an unknown meaning cannot be certified
        // inert — `%C0%AF` (an overlong-UTF-8 `/`) is the classic example.
        guard let segment = percentEncodedSegment.removingPercentEncoding else {
            return false
        }

        // Dot-segments resolve away a path component, which is what turns an
        // injected separator into a different endpoint.
        guard segment != ".", segment != ".." else {
            return false
        }

        // Compared per Unicode *scalar*, not per `Character`. `String.contains`
        // works on grapheme clusters, so `/` followed by a combining mark is a
        // single Character and would NOT match — while the peer, which reads
        // bytes, still sees a separator. Matching the peer's unit of comparison
        // is the whole point of this type.
        //
        // - a decoded separator is a real path boundary, whatever case the
        //   escape was written in (`%2f` decodes exactly as `%2F` does);
        // - a `%` surviving one decode means the value was encoded more than
        //   once — inert at TMDb's edge, which decodes once, but rejecting it
        //   keeps this guard independent of how many times any peer decodes;
        // - a control character can split or truncate the path at the peer.
        return !segment.unicodeScalars.contains { scalar in
            scalar == "/" || scalar == "%" || scalar.value < 0x20 || scalar.value == 0x7F
        }
    }

}
