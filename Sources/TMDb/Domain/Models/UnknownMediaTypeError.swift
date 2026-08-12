//
//  UnknownMediaTypeError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The error thrown when TMDb sends a `media_type` this library does not model.
///
/// This is the **one** decode failure the package tolerates: a tolerant array skips
/// the element that threw it and counts the drop, while every other error propagates
/// and fails the response. See `knowledge/decisions/0019-decode-tolerance-policy.md`.
///
/// It is deliberately not public. Every discriminator that throws it sits inside a
/// tolerant container, so it is caught before it can reach a caller — a discriminator
/// with no tolerant container above it keeps throwing `DecodingError`, which is what
/// ``TMDbError/decode(_:)`` continues to carry for consumers.
///
struct UnknownMediaTypeError: Error, Equatable {

    ///
    /// The unmodelled raw value TMDb sent.
    ///
    let rawValue: String

}
