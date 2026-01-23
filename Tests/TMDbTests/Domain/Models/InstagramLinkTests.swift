//
//  InstagramLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct InstagramLinkTests {

    @Test("init with instagramID when ID is nil returns nil")
    func initWithInstagramIDWhenIDIsNilReturnsNil() {
        let instagramLink = InstagramLink(instagramID: nil)

        #expect(instagramLink == nil)
    }

    @Test("init with instagramID when ID is empty string returns nil")
    func initWithInstagramIDWhenIDIsEmptyStringReturnsNil() {
        let instagramLink = InstagramLink(instagramID: "")

        #expect(instagramLink == nil)
    }

    @Test("URL returns post URL")
    func urlReturnsPostURL() throws {
        let instagramID = "barbiethemovie"
        let expectedURL = try #require(URL(string: "https://www.instagram.com/\(instagramID)"))

        let instagramLink = try #require(InstagramLink(instagramID: instagramID))

        #expect(instagramLink.url == expectedURL)
    }

}
