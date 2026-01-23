//
//  ContentRating.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the content rating.
///
public struct ContentRating: Codable, Equatable, Hashable, Sendable {

    ///
    /// ?
    ///
    public let descriptors: [String]

    ///
    /// The ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// The content rating of the tv show.
    ///
    public let rating: String

    /// Creates a content rating object.
    ///
    /// - Parameters:
    ///    - descriptors: Array of....
    ///    - countryCode: ISO 3166-1 country code.
    ///    - rating: The content rating of the tv show
    ///
    public init(descriptors: [String], countryCode: String, rating: String) {
        self.descriptors = descriptors
        self.countryCode = countryCode
        self.rating = rating
    }
}

extension ContentRating {
    private enum CodingKeys: String, CodingKey {
        case rating
        case descriptors
        case countryCode = "iso31661"
    }
}
