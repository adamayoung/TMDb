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

@testable import TMDb
import XCTest

final class VideoTypeTests: XCTestCase {

    func testTrailerVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.trailer.rawValue, "Trailer")
    }

    func testTeaserVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.teaser.rawValue, "Teaser")
    }

    func testClipVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.clip.rawValue, "Clip")
    }

    func testOpeningCreditsVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.openingCredits.rawValue, "Opening Credits")
    }

    func testFeaturetteVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.featurette.rawValue, "Featurette")
    }

    func testBehindTheScenesVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.behindTheScenes.rawValue, "Behind the Scenes")
    }

    func testBloopersVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.bloopers.rawValue, "Bloopers")
    }

    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"videoType\": \"some-value\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).videoType

        XCTAssertEqual(result, .unknown)
    }

}

extension VideoTypeTests {

    private struct MockObject: Decodable {
        let videoType: VideoType
    }

}
