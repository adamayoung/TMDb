//
//  MovieReleaseDatesByCountry.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing movie release dates for a specific country.
///
public struct MovieReleaseDatesByCountry: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Release dates for the country.
    ///
    public let releaseDates: [ReleaseDate]

    ///
    /// Creates a movie release dates by country object.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - releaseDates: Release dates for the country.
    ///
    public init(countryCode: String, releaseDates: [ReleaseDate]) {
        self.countryCode = countryCode
        self.releaseDates = releaseDates
    }

}

extension MovieReleaseDatesByCountry {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case releaseDates
    }

}
