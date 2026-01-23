//
//  TwitterLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TwitterLinkTests {

    @Test("init with twitterID when ID is nil returns nil")
    func initWithTwitterIDWhenIDIsNilReturnsNil() {
        let twitterLint = TwitterLink(twitterID: nil)

        #expect(twitterLint == nil)
    }

    @Test("init with twitterID when ID is empty string returns nil")
    func initWithTwitterIDWhenIDIsEmptyStringReturnsNil() {
        let twitterLint = TwitterLink(twitterID: "")

        #expect(twitterLint == nil)
    }

    @Test("url returns Twitter URL")
    func urlReturnsTwitterURL() throws {
        let twitterID = "barbiethemovie"
        let expectedURL = try #require(URL(string: "https://www.twitter.com/\(twitterID)"))

        let twitterLink = try #require(TwitterLink(twitterID: twitterID))

        #expect(twitterLink.url == expectedURL)
    }

}
