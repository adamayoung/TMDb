//
//  ExternalSourceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ExternalSourceTests {

    @Test("IMDb ID rawValue is imdb_id")
    func imdbIDRawValue() {
        #expect(ExternalSource.imdbID.rawValue == "imdb_id")
    }

    @Test("Facebook ID rawValue is facebook_id")
    func facebookIDRawValue() {
        #expect(ExternalSource.facebookID.rawValue == "facebook_id")
    }

    @Test("Instagram ID rawValue is instagram_id")
    func instagramIDRawValue() {
        #expect(ExternalSource.instagramID.rawValue == "instagram_id")
    }

    @Test("Twitter ID rawValue is twitter_id")
    func twitterIDRawValue() {
        #expect(ExternalSource.twitterID.rawValue == "twitter_id")
    }

    @Test("TVDB ID rawValue is tvdb_id")
    func tvdbIDRawValue() {
        #expect(ExternalSource.tvdbID.rawValue == "tvdb_id")
    }

    @Test("TikTok ID rawValue is tiktok_id")
    func tiktokIDRawValue() {
        #expect(ExternalSource.tiktokID.rawValue == "tiktok_id")
    }

    @Test("YouTube ID rawValue is youtube_id")
    func youtubeIDRawValue() {
        #expect(ExternalSource.youtubeID.rawValue == "youtube_id")
    }

    @Test("Wikidata ID rawValue is wikidata_id")
    func wikidataIDRawValue() {
        #expect(ExternalSource.wikidataID.rawValue == "wikidata_id")
    }

    @Test("JSON decoding of ExternalSource", .tags(.decoding))
    func decodeReturnsExternalSource() throws {
        let data = Data("{\"source\": \"imdb_id\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).source

        #expect(result == .imdbID)
    }

}

extension ExternalSourceTests {

    private struct MockObject: Decodable {
        let source: ExternalSource
    }

}
