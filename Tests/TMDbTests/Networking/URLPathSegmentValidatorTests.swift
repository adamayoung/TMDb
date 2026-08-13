//
//  URLPathSegmentValidatorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.networking))
struct URLPathSegmentValidatorTests {

    @Test(
        "isSafe is true for a path built from real TMDb identifiers",
        arguments: [
            "/find/tt0111161",
            "/credit/52fe4250c3a36847f80149f3",
            "/tv/episode_group/5acf93e60e0a26346d0000ce",
            "/account/abc123/lists",
            "/guest_session/abc123/rated/movies",
            "/movie/550/credits",
            "/find/Q190050",
            "/credit/a-b_c.d~e"
        ]
    )
    func isSafeForRealIdentifiers(path: String) {
        #expect(URLPathSegmentValidator.isSafe(path: path))
    }

    @Test(
        "isSafe is false for a literal dot-segment",
        arguments: ["/credit/..", "/account/../lists", "/credit/.", "/account/./lists"]
    )
    func isSafeIsFalseForLiteralDotSegment(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    /// The TMDb edge percent-decodes the path before routing, and that decode is
    /// case-insensitive — `%2f` traverses exactly as `%2F` does. Decoding rather
    /// than matching on the literal `%2F` is what makes both cases inert.
    @Test(
        "isSafe is false for an encoded separator, in either case",
        arguments: ["/credit/x%2Fy", "/credit/x%2fy", "/account/a%2Fb/lists"]
    )
    func isSafeIsFalseForEncodedSeparator(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    @Test(
        "isSafe is false for an encoded dot-segment, in either case",
        arguments: ["/credit/%2E%2E", "/credit/%2e%2e", "/credit/%2E"]
    )
    func isSafeIsFalseForEncodedDotSegment(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    @Test("isSafe is false for the reported traversal payload")
    func isSafeIsFalseForReportedTraversalPayload() {
        #expect(!URLPathSegmentValidator.isSafe(path: "/credit/x%2F..%2F..%2Fmovie%2F550"))
        #expect(!URLPathSegmentValidator.isSafe(path: "/credit/x%2f%2e%2e%2f%2e%2e%2fmovie%2f550"))
    }

    /// TMDb's edge decodes exactly once today (a double-encoded payload 404s), so
    /// this is defence in depth: rejecting a segment that still contains `%` after
    /// one decode means the guard does not depend on how many times a peer decodes.
    @Test(
        "isSafe is false for a double-encoded payload",
        arguments: ["/credit/x%252F..%252F..%252Fmovie%252F550", "/credit/%252E%252E"]
    )
    func isSafeIsFalseForDoubleEncodedPayload(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    /// Fail closed: a segment the library cannot decode is a segment whose meaning
    /// to the peer is unknown, so it must never be accepted as-is.
    @Test(
        "isSafe is false for a segment containing a malformed escape",
        arguments: ["/credit/a%zz", "/credit/a%2", "/credit/100%", "/credit/%"]
    )
    func isSafeIsFalseForMalformedEscape(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    /// A distinct branch of the same fail-closed rule: these escapes are
    /// syntactically well-formed, so they get past the parse and fail on the
    /// *UTF-8* decode instead. `%C0%AF` is an overlong-encoded `/` — the shape the
    /// validator's own documentation cites — and it must not survive.
    @Test(
        "isSafe is false for a segment that decodes to invalid UTF-8",
        arguments: ["/credit/%C0%AF", "/credit/a%C0%AFb", "/credit/%E0%80%AF", "/credit/%ED%A0%80", "/credit/%FF"]
    )
    func isSafeIsFalseForInvalidUTF8(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    /// `String.contains` compares grapheme clusters, so a `/` or `%` followed by a
    /// combining mark is one Character and does not match — while the peer, which
    /// reads bytes, still sees the separator. The check is therefore scalar-based,
    /// and these pin that: `%CC%81` is U+0301 COMBINING ACUTE ACCENT.
    @Test(
        "isSafe is false for a separator hidden inside a grapheme cluster",
        arguments: [
            "/credit/x%2F%CC%81..%2F%CC%81..%2Fmovie",
            "/credit/x%2F%E2%80%8Dy",
            "/credit/x%25%CC%81y"
        ]
    )
    func isSafeIsFalseForSeparatorInGraphemeCluster(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    @Test(
        "isSafe is false for a segment containing a control character",
        arguments: ["/credit/..%00", "/credit/a%0Ab", "/credit/a%09b", "/credit/a%7Fb"]
    )
    func isSafeIsFalseForControlCharacter(path: String) {
        #expect(!URLPathSegmentValidator.isSafe(path: path))
    }

    @Test(
        "isSafe is true for a degenerate path with no meaningful segments",
        arguments: ["", "/", "//", "/credit/", "//credit//550//"]
    )
    func isSafeForDegeneratePath(path: String) {
        #expect(URLPathSegmentValidator.isSafe(path: path))
    }

}
