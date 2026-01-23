//
//  FindByIDRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .find))
struct FindByIDRequestTests {

    @Test("path is correct with IMDb ID")
    func pathWithIMDbID() {
        let request = FindByIDRequest(externalID: "tt0111161", externalSource: .imdbID)

        #expect(request.path == "/find/tt0111161")
    }

    @Test("path is correct with TVDB ID")
    func pathWithTVDBID() {
        let request = FindByIDRequest(externalID: "81189", externalSource: .tvdbID)

        #expect(request.path == "/find/81189")
    }

    @Test("queryItems with IMDb external source")
    func queryItemsWithIMDbExternalSource() {
        let request = FindByIDRequest(externalID: "tt0111161", externalSource: .imdbID)

        #expect(request.queryItems == ["external_source": "imdb_id"])
    }

    @Test("queryItems with TVDB external source")
    func queryItemsWithTVDBExternalSource() {
        let request = FindByIDRequest(externalID: "81189", externalSource: .tvdbID)

        #expect(request.queryItems == ["external_source": "tvdb_id"])
    }

    @Test("queryItems with Facebook external source")
    func queryItemsWithFacebookExternalSource() {
        let request = FindByIDRequest(externalID: "somefacebookid", externalSource: .facebookID)

        #expect(request.queryItems == ["external_source": "facebook_id"])
    }

    @Test("queryItems with Instagram external source")
    func queryItemsWithInstagramExternalSource() {
        let request = FindByIDRequest(externalID: "someinstagramid", externalSource: .instagramID)

        #expect(request.queryItems == ["external_source": "instagram_id"])
    }

    @Test("queryItems with Twitter external source")
    func queryItemsWithTwitterExternalSource() {
        let request = FindByIDRequest(externalID: "sometwitterid", externalSource: .twitterID)

        #expect(request.queryItems == ["external_source": "twitter_id"])
    }

    @Test("queryItems with TikTok external source")
    func queryItemsWithTikTokExternalSource() {
        let request = FindByIDRequest(externalID: "sometiktokid", externalSource: .tiktokID)

        #expect(request.queryItems == ["external_source": "tiktok_id"])
    }

    @Test("queryItems with YouTube external source")
    func queryItemsWithYouTubeExternalSource() {
        let request = FindByIDRequest(externalID: "someyoutubeid", externalSource: .youtubeID)

        #expect(request.queryItems == ["external_source": "youtube_id"])
    }

    @Test("queryItems with Wikidata external source")
    func queryItemsWithWikidataExternalSource() {
        let request = FindByIDRequest(externalID: "Q123456", externalSource: .wikidataID)

        #expect(request.queryItems == ["external_source": "wikidata_id"])
    }

    @Test("queryItems with external source and language")
    func queryItemsWithExternalSourceAndLanguage() {
        let request = FindByIDRequest(
            externalID: "tt0111161",
            externalSource: .imdbID,
            language: "en"
        )

        #expect(request.queryItems == ["external_source": "imdb_id", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = FindByIDRequest(externalID: "tt0111161", externalSource: .imdbID)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = FindByIDRequest(externalID: "tt0111161", externalSource: .imdbID)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = FindByIDRequest(externalID: "tt0111161", externalSource: .imdbID)

        #expect(request.body == nil)
    }

}
