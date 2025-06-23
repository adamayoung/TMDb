//
//  FindServiceType.swift
//  TMDb
//
//  Created by MLabs on 23/06/2025.
//


public enum FindServiceType: String, CodingKey {
    case imdbID = "imdb_id"
    case facebookID = "facebook_id"
    case instagramID = "instagram_id"
    case twitterID = "twitter_id"
    case theTVDB = "tvdb_id"
    case tikTok = "tiktok_id"
    case wikidata = "wikidata_id"
    case youTube = "youtube_id"
}
