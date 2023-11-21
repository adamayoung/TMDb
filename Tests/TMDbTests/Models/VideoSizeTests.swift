//
//  VideoSizeTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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
        let data = "{\"videoSize\": 999}".data(using: .utf8)!
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
