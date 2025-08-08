//
//  WikiDataLinkTests.swift
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
