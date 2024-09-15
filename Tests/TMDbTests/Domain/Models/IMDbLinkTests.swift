//
//  IMDbLinkTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
struct IMDbLinkTests {

    @Test("init with IMDB title ID when ID is nil returns nil")
    func initWithIMDbTitleIDWhenIDIsNilReturnsNil() {
        let imdbLink = IMDbLink(imdbTitleID: nil)

        #expect(imdbLink == nil)
    }

    @Test("init with IMDB name ID when ID is nil returns nil")
    func initWithIMDbNameIDWhenIDIsNilReturnsNil() {
        let imdbLink = IMDbLink(imdbNameID: nil)

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
