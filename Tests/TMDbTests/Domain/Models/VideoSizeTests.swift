//
//  VideoSizeTests.swift
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
struct VideoSizeTests {

    @Test("s360 video size rawValue is 360")
    func s360VideoSizeReturnsRawValue() {
        #expect(VideoSize.s360.rawValue == 360)
    }

    @Test("s480 video size rawValue is 480")
    func s480VideoSizeReturnsRawValue() {
        #expect(VideoSize.s480.rawValue == 480)
    }

    @Test("s720 video size rawValue is 720")
    func s720VideoSizeReturnsRawValue() {
        #expect(VideoSize.s720.rawValue == 720)
    }

    @Test("s1080 video size rawValue is 1080")
    func s1080VideoSizeReturnsRawValue() {
        #expect(VideoSize.s1080.rawValue == 1080)
    }

    @Test("JSON decoding of VideoSize", .tags(.decoding))
    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"videoSize\": 999}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).videoSize

        #expect(result == .unknown)
    }

}

extension VideoSizeTests {

    private struct MockObject: Decodable {
        let videoSize: VideoSize
    }

}
