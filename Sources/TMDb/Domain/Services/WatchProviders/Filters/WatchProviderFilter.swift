//
//  WatchProviderFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for fetching watch providers.
///
public struct WatchProviderFilter {

    ///
    /// ISO-3166-1 country code to filter results for.
    ///
    public let country: String?

    ///
    /// Creates a watch provider filter.
    ///
    /// - Parameter country: ISO-3166-1 country code to filter results for.
    ///
    public init(country: String? = nil) {
        self.country = country
    }

}
