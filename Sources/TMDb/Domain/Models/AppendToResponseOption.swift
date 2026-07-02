//
//  AppendToResponseOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An `append_to_response` option set whose selected members serialise to the
/// comma-separated query value TMDb expects.
///
/// Each conforming type supplies only its ``mapping`` (option → TMDb token);
/// the ``queryValue`` serialisation is shared, since it is identical for every
/// append-to-response family.
///
protocol AppendToResponseOption: OptionSet where Element == Self {

    /// Maps each individual option to its TMDb `append_to_response` token,
    /// in the order it should appear in the query value.
    static var mapping: [(Self, String)] { get }

}

extension AppendToResponseOption {

    /// The selected options as a comma-separated `append_to_response` value.
    var queryValue: String {
        Self.mapping
            .filter { contains($0.0) }
            .map(\.1)
            .joined(separator: ",")
    }

}
