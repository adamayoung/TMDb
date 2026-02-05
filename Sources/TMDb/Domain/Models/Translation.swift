//
//  Translation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a translation for a media item.
///
public struct Translation<DataType: Codable & Equatable & Hashable & Sendable>: Codable, Equatable, Hashable,
Sendable {

    ///
    /// The ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// The ISO 639-1 language code.
    ///
    public let languageCode: String

    ///
    /// The localized language name.
    ///
    public let name: String

    ///
    /// The English language name.
    ///
    public let englishName: String

    ///
    /// The translated data specific to the media type.
    ///
    public let data: DataType

    ///
    /// Creates a translation object.
    ///
    /// - Parameters:
    ///    - countryCode: The ISO 3166-1 country code.
    ///    - languageCode: The ISO 639-1 language code.
    ///    - name: The localized language name.
    ///    - englishName: The English language name.
    ///    - data: The translated data specific to the media type.
    ///
    public init(
        countryCode: String,
        languageCode: String,
        name: String,
        englishName: String,
        data: DataType
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
public struct TranslationCollection<DataType: Codable & Equatable & Hashable & Sendable>: Codable, Equatable,
Hashable, Sendable {

    ///
    /// The media item identifier.
    ///
    public let id: Int

    ///
    /// The list of translations.
    ///
    public let translations: [Translation<DataType>]

    ///
    /// Creates a translation collection object.
    ///
    /// - Parameters:
    ///    - id: The media item identifier.
    ///    - translations: The list of translations.
    ///
    public init(id: Int, translations: [Translation<DataType>]) {
        self.id = id
        self.translations = translations
    }

}

///
/// A model representing movie-specific translation data.
///
public struct MovieTranslationData: Codable, Equatable, Hashable, Sendable {

    ///
    /// The translated movie title.
    ///
    public let title: String

    ///
    /// The translated movie overview.
    ///
    public let overview: String

    ///
    /// The translated movie homepage URL.
    ///
    public let homepage: String?

    ///
    /// The translated movie tagline.
    ///
    public let tagline: String?

    ///
    /// Creates a movie translation data object.
    ///
    /// - Parameters:
    ///    - title: The translated movie title.
    ///    - overview: The translated movie overview.
    ///    - homepage: The translated movie homepage URL.
    ///    - tagline: The translated movie tagline.
    ///
    public init(title: String, overview: String, homepage: String? = nil, tagline: String? = nil) {
        self.title = title
        self.overview = overview
        self.homepage = homepage
        self.tagline = tagline
    }

}

///
/// A model representing TV series-specific translation data.
///
public struct TVSeriesTranslationData: Codable, Equatable, Hashable, Sendable {

    ///
    /// The translated TV series name.
    ///
    public let name: String

    ///
    /// The translated TV series overview.
    ///
    public let overview: String

    ///
    /// The translated TV series homepage URL.
    ///
    public let homepage: String?

    ///
    /// The translated TV series tagline.
    ///
    public let tagline: String?

    ///
    /// Creates a TV series translation data object.
    ///
    /// - Parameters:
    ///    - name: The translated TV series name.
    ///    - overview: The translated TV series overview.
    ///    - homepage: The translated TV series homepage URL.
    ///    - tagline: The translated TV series tagline.
    ///
    public init(name: String, overview: String, homepage: String? = nil, tagline: String? = nil) {
        self.name = name
        self.overview = overview
        self.homepage = homepage
        self.tagline = tagline
    }

}

///
/// A model representing person-specific translation data.
///
public struct PersonTranslationData: Codable, Equatable, Hashable,
Sendable {

    ///
    /// The translated biography.
    ///
    public let biography: String

    ///
    /// Creates a person translation data object.
    ///
    /// - Parameter biography: The translated biography.
    ///
    public init(biography: String) {
        self.biography = biography
    }

}
