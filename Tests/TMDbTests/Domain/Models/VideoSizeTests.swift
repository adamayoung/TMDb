//
//  VideoSizeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
    func decodeWhenInvalidValueReturnsUnknown() throws {
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
