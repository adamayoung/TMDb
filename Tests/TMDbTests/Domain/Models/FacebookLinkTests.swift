//
//  FacebookLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct FacebookLinkTests {

    @Test("Init with Facebook ID when ID is nil returns nil")
    func initWithFacebookIDWhenIDIsNilReturnsNil() {
        let facebookLink = FacebookLink(facebookID: nil)

        #expect(facebookLink == nil)
    }

    @Test("Init with Facebook ID when ID is empty string returns nil")
    func initWithFacebookIDWhenIDIsEmptyStringReturnsNil() {
        let facebookLink = FacebookLink(facebookID: "")

        #expect(facebookLink == nil)
    }

    @Test("Facebook URL")
    func uRL() throws {
        let facebookID = "BarbieTheMovie"
        let expectedURL = try #require(URL(string: "https://www.facebook.com/\(facebookID)"))

        let facebookLink = try #require(FacebookLink(facebookID: facebookID))

        #expect(facebookLink.url == expectedURL)
    }

}
