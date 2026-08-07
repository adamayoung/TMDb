//
//  FailableDecodable.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A decoding wrapper that tolerates a failing element.
///
/// Decoding never throws: when the wrapped value cannot be decoded, ``value``
/// is `nil` and the element is consumed so the surrounding array continues to
/// decode. This lets a list skip an unrecognised element instead of dropping
/// the whole page.
///
/// - Important: A dropped element is **silent**. Any model using this should
///   pair it with an assertion reconciling the decoded count against the
///   count the API reports, or a decoder regression shows up as a quietly
///   short page rather than a failure.
///
struct FailableDecodable<Wrapped: Decodable>: Decodable {

    let value: Wrapped?

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(Wrapped.self)
    }

}
