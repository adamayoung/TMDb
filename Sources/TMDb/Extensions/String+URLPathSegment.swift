//
//  String+URLPathSegment.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension String {

    ///
    /// The string percent-encoded for safe use as a single URL path segment.
    ///
    /// Every character other than the RFC 3986 *unreserved* set
    /// (`A`–`Z`, `a`–`z`, `0`–`9`, `-`, `.`, `_`, `~`) is percent-encoded, so an
    /// interpolated value cannot break out of its segment to inject additional
    /// path components (`/`), a query string (`?`), or a fragment (`#`).
    ///
    var urlPathSegmentEncoded: String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._~")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? self
    }

}
