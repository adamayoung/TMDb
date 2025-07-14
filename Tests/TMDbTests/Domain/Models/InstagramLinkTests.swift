//
//  InstagramLinkTests.swift
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
