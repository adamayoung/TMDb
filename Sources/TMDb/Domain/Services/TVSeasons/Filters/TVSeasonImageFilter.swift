//
//  TVSeasonImageFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for fetching TV season images.
///
public struct TVSeasonImageFilter: Sendable {

    ///
    /// A list of ISO 639-1 language codes to filter images by.
    ///
    public let languages: [String]?

    ///
    /// Creates a TV season image filter.
    ///
    /// - Parameter languages: A list of ISO 639-1 language codes to filter images by.
    ///
    public init(languages: [String]? = nil) {
        self.languages = languages
    }

}
