//
//  AlternativeTitle.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an alternative title for a media item.
///
public struct AlternativeTitle: Codable, Equatable, Hashable, Sendable {

    ///
    /// The ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// The alternative title.
    ///
    public let title: String

    ///
    /// The type of alternative title.
    ///
    /// Examples include "Alternative Title", "Working Title", etc.
    ///
    public let type: String?

    ///
    /// Creates an alternative title object.
    ///
    /// - Parameters:
    ///    - countryCode: The ISO 3166-1 country code.
    ///    - title: The alternative title.
    ///    - type: The type of alternative title.
    ///
    public init(countryCode: String, title: String, type: String? = nil) {
        self.countryCode = countryCode
        self.title = title
        self.type = type
    }

}

extension AlternativeTitle {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case title
        case type
    }

}
