//
//  AlternativeTitle.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an alternative title.
///
public struct AlternativeTitle: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Title.
    ///
    public let title: String

    ///
    /// Type of alternative title.
    ///
    public let type: String?

    ///
    /// Creates an alternative title object.
    ///
    /// - Parameters:
    ///   - countryCode: ISO 3166-1 country code.
    ///   - title: Title.
    ///   - type: Type of alternative title.
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
