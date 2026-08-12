//
//  UnknownMediaTypeError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Marks the one decode failure the package tolerates: TMDb sent a `media_type` this
/// library does not model.
///
/// It is never thrown on its own. It travels as the `underlyingError` of a
/// `DecodingError.dataCorrupted`, so what actually crosses the API boundary is always
/// a `DecodingError` — the type every public `init(from:)` documents, that
/// ``TMDbError/decode(_:)`` carries, and that a consumer decoding their own cached
/// JSON can still `catch` by type. This marker only tells the tolerant array wrapper
/// which `DecodingError` it may skip.
///
/// Carrying it inside a `DecodingError` rather than throwing it directly also removes
/// any question of whether a custom error survives a given platform's `JSONDecoder`:
/// a `DecodingError` is that decoder's own currency.
///
/// See `knowledge/decisions/0019-decode-tolerance-policy.md`.
///
struct UnknownMediaTypeError: Error, Equatable {

    ///
    /// The unmodelled raw value TMDb sent.
    ///
    let rawValue: String

}

extension DecodingError {

    ///
    /// Wraps an unmodelled media type as a `DecodingError`, so the failure that
    /// crosses the API boundary is the type every public `init(from:)` documents.
    ///
    /// - Parameters:
    ///    - rawValue: The unmodelled raw value TMDb sent.
    ///    - codingPath: The path to the offending value.
    ///
    /// - Returns: A `dataCorrupted` error carrying ``UnknownMediaTypeError``.
    ///
    static func unknownMediaType(
        rawValue: String,
        codingPath: [any CodingKey]
    ) -> DecodingError {
        .dataCorrupted(
            Context(
                codingPath: codingPath,
                // Bounded and escaped: this string reaches a public error a caller
                // may log, and the value comes straight off the wire. A raw one
                // would let a response forge log lines with newlines, or bloat a
                // log with a multi-megabyte media type. The untruncated value stays
                // on the internal `UnknownMediaTypeError`, which never escapes.
                debugDescription: "Unknown media type: \(redacting(rawValue))",
                underlyingError: UnknownMediaTypeError(rawValue: rawValue)
            )
        )
    }

    private static func redacting(_ rawValue: String) -> String {
        String(
            rawValue.prefix(32).map { character in
                character.isLetter || character.isNumber || character == "_" || character == "-"
                    ? character
                    : "?"
            }
        )
    }

    ///
    /// The unmodelled media type this error was raised for, if it was.
    ///
    /// This is the only decode failure a tolerant array may skip; every other
    /// `DecodingError` propagates.
    ///
    var unknownMediaType: UnknownMediaTypeError? {
        switch self {
        case .dataCorrupted(let context),
             .keyNotFound(_, let context),
             .typeMismatch(_, let context),
             .valueNotFound(_, let context):
            context.underlyingError as? UnknownMediaTypeError

        @unknown default:
            nil
        }
    }

}
