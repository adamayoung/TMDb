//
//  MovieVideoFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for fetching movie videos.
///
public struct MovieVideoFilter {

    ///
    /// A list of ISO 639-1 language codes to filter videos by.
    ///
    public let languages: [String]?

    ///
    /// Creates a movie video filter.
    ///
    /// - Parameter languages: A list of ISO 639-1 language codes to filter images by.
    ///
    public init(languages: [String]? = nil) {
        self.languages = languages
    }

}
