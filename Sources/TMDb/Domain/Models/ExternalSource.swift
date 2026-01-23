//
//  ExternalSource.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
