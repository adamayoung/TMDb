//
//  TikTokLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TikTokLinkTests {

    @Test("init with TikTok ID when ID is nil returns nil")
    func initWithTikTokIDWhenIDIsNilReturnsNil() {
        let tikTokLink = TikTokLink(tikTokID: nil)

        #expect(tikTokLink == nil)
    }

    @Test("init with TikTok ID when ID is empty string returns nil")
    func initWithTikTokIDWhenIDIsEmptyStringReturnsNil() {
        let tikTokLink = TikTokLink(tikTokID: "")

        #expect(tikTokLink == nil)
    }

    @Test("url returns TikTok URL")
    func urlReturnsTikTokURL() throws {
        let tikTokID = "jasonstatham"
        let expectedURL = try #require(URL(string: "https://www.tiktok.com/@\(tikTokID)"))

        let tikTokLink = try #require(TikTokLink(tikTokID: tikTokID))

        #expect(tikTokLink.url == expectedURL)
    }

}
