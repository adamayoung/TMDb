//
//  CollectionTranslationData.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing collection translation data.
///
public struct CollectionTranslationData: Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection title.
    ///
    public let title: String

    ///
    /// Collection overview.
    ///
    public let overview: String

    ///
    /// Collection's home page URL.
    ///
    public let homepageURL: URL?

    ///
    /// Creates a collection translation data object.
    ///
    /// - Parameters:
    ///    - title: Collection title.
    ///    - overview: Collection overview.
    ///    - homepageURL: Collection's home page URL.
    ///
    public init(
        title: String,
        overview: String,
        homepageURL: URL? = nil
    ) {
        self.title = title
        self.overview = overview
        self.homepageURL = homepageURL
    }

}

extension CollectionTranslationData {

    private enum CodingKeys: String, CodingKey {
        case title
        case overview
        case homepageURL = "homepage"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if decoding fails.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)

        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return URL(string: homepageURLString)
        }()
    }

}
