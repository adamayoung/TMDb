//
//  IMDbLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct IMDbLinkTests {

    @Test("init with IMDB title ID when ID is nil returns nil")
    func initWithIMDbTitleIDWhenIDIsNilReturnsNil() {
        let imdbLink = IMDbLink(imdbTitleID: nil)

        #expect(imdbLink == nil)
    }

    @Test("init with IMDB title ID when ID is empty string returns nil")
    func initWithIMDbTitleIDWhenIDIsEmptyStringReturnsNil() {
        let imdbLink = IMDbLink(imdbTitleID: "")

        #expect(imdbLink == nil)
    }

    @Test("init with IMDB name ID when ID is nil returns nil")
    func initWithIMDbNameIDWhenIDIsNilReturnsNil() {
        let imdbLink = IMDbLink(imdbNameID: nil)

        #expect(imdbLink == nil)
    }

    @Test("init with IMDB name ID when ID is empty string returns nil")
    func initWithIMDbNameIDWhenIDIsEmptyStringReturnsNil() {
        let imdbLink = IMDbLink(imdbNameID: "")

        #expect(imdbLink == nil)
    }

    @Test("URL when using title ID returns show URL")
    func urlWhenUsingTitleIDReturnsShowURL() throws {
        let imdbID = "tt1517268"
        let expectedURL = try #require(URL(string: "https://www.imdb.com/title/\(imdbID)/"))

        let imdbLink = try #require(IMDbLink(imdbTitleID: imdbID))

        #expect(imdbLink.url == expectedURL)
    }

    @Test("URL when using name ID returns person URL")
    func urlWhenUsingNameIDReturnsPersonURL() throws {
        let imdbID = "nm3592338"
        let expectedURL = try #require(URL(string: "https://www.imdb.com/name/\(imdbID)/"))

        let imdbLink = try #require(IMDbLink(imdbNameID: imdbID))

        #expect(imdbLink.url == expectedURL)
    }

}
