//
//  TVEpisodeImageFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for fetching TV episode images.
///
public struct TVEpisodeImageFilter {

    ///
    /// A list of ISO 639-1 language codes to filter images by.
    ///
    public let languages: [String]?

    ///
    /// Creates a TV episode image filter.
    ///
    /// - Parameter languages: A list of ISO 639-1 language codes to filter images by.
    ///
    public init(languages: [String]? = nil) {
        self.languages = languages
    }

}
