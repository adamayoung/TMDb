//
//  VideoTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
