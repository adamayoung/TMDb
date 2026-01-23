//
//  CollectionTranslation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection translation.
///
public struct CollectionTranslation: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection translation's identifier (same as `languageCode`).
    ///
    public var id: String { languageCode }

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String

    ///
    /// Language name.
    ///
    public let name: String

    ///
    /// English language name.
    ///
    public let englishName: String

    ///
    /// Translation data.
    ///
    public let data: CollectionTranslationData

    ///
    /// Creates a collection translation object.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - languageCode: ISO 639-1 language code.
    ///    - name: Language name.
    ///    - englishName: English language name.
    ///    - data: Translation data.
    ///
    public init(
        countryCode: String,
        languageCode: String,
        name: String,
        englishName: String,
        data: CollectionTranslationData
    ) {
        self.countryCode = countryCode
        self.languageCode = languageCode
        self.name = name
        self.englishName = englishName
        self.data = data
    }

}

extension CollectionTranslation {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso_3166_1"
        case languageCode = "iso_639_1"
        case name
        case englishName = "english_name"
        case data
    }

}
