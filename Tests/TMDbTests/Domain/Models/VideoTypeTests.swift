//
//  VideoTypeTests.swift
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
struct VideoTypeTests {

    @Test("trailer video type rawValue is Trailer")
    func trailerVideoTypeReturnsRawValue() {
        #expect(VideoType.trailer.rawValue == "Trailer")
    }

    @Test("teaser video type rawValue is Teaser")
    func teaserVideoTypeReturnsRawValue() {
        #expect(VideoType.teaser.rawValue == "Teaser")
    }

    @Test("clip video type rawValue is Clip")
    func clipVideoTypeReturnsRawValue() {
        #expect(VideoType.clip.rawValue == "Clip")
    }

    @Test("openingCredits video type rawValue is Opening Credits")
    func openingCreditsVideoTypeReturnsRawValue() {
        #expect(VideoType.openingCredits.rawValue == "Opening Credits")
    }

    @Test("featurette video type rawValue is Featurette")
    func featuretteVideoTypeReturnsRawValue() {
        #expect(VideoType.featurette.rawValue == "Featurette")
    }

    @Test("behindTheScenes video type rawValue is Behind the Scenes")
    func behindTheScenesVideoTypeReturnsRawValue() {
        #expect(VideoType.behindTheScenes.rawValue == "Behind the Scenes")
    }

    @Test("bloopers video type rawValue is Bloopers")
    func bloopersVideoTypeReturnsRawValue() {
        #expect(VideoType.bloopers.rawValue == "Bloopers")
    }

    @Test("JSON decoding of VideoType", .tags(.decoding))
    func decodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"videoType\": \"some-value\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).videoType

        #expect(result == .unknown)
    }

}

extension VideoTypeTests {

    private struct MockObject: Decodable {
        let videoType: VideoType
    }

}
