//
//  WikiDataLinkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct WikiDataLinkTests {

    @Test("init with wikiDataID when ID is nil returns nil")
    func initWithWikiDataIDWhenIDIsNilReturnsNil() {
        let wikiDataLink = WikiDataLink(wikiDataID: nil)

        #expect(wikiDataLink == nil)
    }

    @Test("init with wikiDataID when ID is empty string returns nil")
    func initWithWikiDataIDWhenIDIsEmptyStringReturnsNil() {
        let wikiDataLink = WikiDataLink(wikiDataID: "")

        #expect(wikiDataLink == nil)
    }

    @Test("url returns WikiData URL")
    func urlReturnsWikiDataURL() throws {
        let wikiDataID = "Q55436290"
        let expectedURL = try #require(URL(string: "https://www.wikidata.org/wiki/\(wikiDataID)"))

        let wikiDataLink = try #require(WikiDataLink(wikiDataID: wikiDataID))

        #expect(wikiDataLink.url == expectedURL)
    }

}
