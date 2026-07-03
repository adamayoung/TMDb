//
//  StringCodingKey.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A dynamic coding key addressed by its string value.
///
/// Lets nested-container decoding address a JSON key by name without declaring a
/// bespoke `CodingKey` enum for each wrapper object.
///
struct StringCodingKey: CodingKey {

    let stringValue: String
    let intValue: Int? = nil

    init(_ stringValue: String) {
        self.stringValue = stringValue
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue _: Int) {
        nil
    }

}
