//
//  ShowWatchProvidersByCountry.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing watch provider information for a specific country.
///
public struct ShowWatchProvidersByCountry: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Watch provider information for this country.
    ///
    public let watchProviders: ShowWatchProvider

    ///
    /// Creates a show watch providers by country object.
    ///
    /// - Parameters:
    ///   - countryCode: ISO 3166-1 country code.
    ///   - watchProviders: Watch provider information for this country.
    ///
    public init(countryCode: String, watchProviders: ShowWatchProvider) {
        self.countryCode = countryCode
        self.watchProviders = watchProviders
    }

}
