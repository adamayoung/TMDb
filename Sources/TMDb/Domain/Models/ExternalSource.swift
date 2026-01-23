//
//  ExternalSource.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An external source for finding movies, TV shows, and people.
///
public enum ExternalSource: String, Codable, Equatable, Hashable, Sendable, CaseIterable {

    ///
    /// IMDb ID.
    ///
    case imdbID = "imdb_id"

    ///
    /// Facebook ID.
    ///
    case facebookID = "facebook_id"

    ///
    /// Instagram ID.
    ///
    case instagramID = "instagram_id"

    ///
    /// Twitter ID.
    ///
    case twitterID = "twitter_id"

    ///
    /// TVDB ID.
    ///
    case tvdbID = "tvdb_id"

    ///
    /// TikTok ID.
    ///
    case tiktokID = "tiktok_id"

    ///
    /// YouTube ID.
    ///
    case youtubeID = "youtube_id"

    ///
    /// Wikidata ID.
    ///
    case wikidataID = "wikidata_id"

}
