//
//  Translation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a translation.
///
public struct Translation<Data: Codable & Equatable & Hashable & Sendable>:
Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Translation's identifier (same as `languageCode`).
    ///
    public var id: String {
        languageCode
    }

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
    public let data: Data

    ///
    /// Creates a translation object.
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
        data: Data
    ) {
        self.countryCode = countryCode
        self.languageCode = languageCode
        self.name = name
        self.englishName = englishName
        self.data = data
    }

}

extension Translation {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case languageCode = "iso6391"
        case name
        case englishName
        case data
    }

}

///
/// A model representing a collection of translations.
///
public struct TranslationCollection<Data: Codable & Equatable & Hashable & Sendable>:
Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Translations.
    ///
    public let translations: [Translation<Data>]

    ///
    /// Creates a translation collection object.
    ///
    /// - Parameters:
    ///   - id: Media identifier.
    ///   - translations: Translations.
    ///
    public init(id: Int, translations: [Translation<Data>]) {
        self.id = id
        self.translations = translations
    }

}

///
/// A model representing TV series translation data.
///
public struct TVSeriesTranslationData: Codable, Equatable, Hashable, Sendable {

    ///
    /// TV series name.
    ///
    public let name: String

    ///
    /// TV series overview.
    ///
    public let overview: String

    ///
    /// TV series homepage URL.
    ///
    public let homepage: String?

    ///
    /// TV series tagline.
    ///
    public let tagline: String?

    ///
    /// Creates a TV series translation data object.
    ///
    /// - Parameters:
    ///   - name: TV series name.
    ///   - overview: TV series overview.
    ///   - homepage: TV series homepage URL.
    ///   - tagline: TV series tagline.
    ///
    public init(
        name: String,
        overview: String,
        homepage: String? = nil,
        tagline: String? = nil
    ) {
        self.name = name
        self.overview = overview
        self.homepage = homepage
        self.tagline = tagline
    }

}
