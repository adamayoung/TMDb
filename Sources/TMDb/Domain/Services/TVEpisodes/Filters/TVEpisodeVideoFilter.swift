//
//  TVEpisodeVideoFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for fetching TV episode videos.
///
public struct TVEpisodeVideoFilter {

    ///
    /// A list of ISO 639-1 language codes to filter videos by.
    ///
    public let languages: [String]?

    ///
    /// Creates a TV season video filter.
    ///
    /// - Parameter languages: A list of ISO 639-1 language codes to filter videos by.
    ///
    public init(languages: [String]? = nil) {
        self.languages = languages
    }

}
