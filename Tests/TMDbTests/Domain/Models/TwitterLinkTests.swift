//
//  TwitterLinkTests.swift
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
