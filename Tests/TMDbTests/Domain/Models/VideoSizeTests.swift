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

@testable import TMDb
import XCTest

final class VideoSizeTests: XCTestCase {

    func test360VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s360.rawValue, 360)
    }

    func test480VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s480.rawValue, 480)
    }

    func test720VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s720.rawValue, 720)
    }

    func test1080VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s1080.rawValue, 1080)
    }

    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"videoSize\": 999}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).videoSize

        XCTAssertEqual(result, .unknown)
    }

}

extension VideoSizeTests {

    private struct MockObject: Decodable {
        let videoSize: VideoSize
    }

}
