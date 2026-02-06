//
//  TVEpisodeAppendOptionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVEpisodeAppendOptionTests {

    @Test("queryValue for credits")
    func queryValueForCredits() {
        let option: TVEpisodeAppendOption = .credits

        #expect(option.queryValue == "credits")
    }

    @Test("queryValue for images")
    func queryValueForImages() {
        let option: TVEpisodeAppendOption = .images

        #expect(option.queryValue == "images")
    }

    @Test("queryValue for videos")
    func queryValueForVideos() {
        let option: TVEpisodeAppendOption = .videos

        #expect(option.queryValue == "videos")
    }

    @Test("queryValue for translations")
    func queryValueForTranslations() {
        let option: TVEpisodeAppendOption = .translations

        #expect(option.queryValue == "translations")
    }

    @Test("queryValue for externalIDs")
    func queryValueForExternalIDs() {
        let option: TVEpisodeAppendOption = .externalIDs

        #expect(option.queryValue == "external_ids")
    }

    @Test("queryValue for multiple options")
    func queryValueForMultipleOptions() {
        let options: TVEpisodeAppendOption = [.credits, .images]

        let value = options.queryValue
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryValue for all options")
    func queryValueForAllOptions() {
        let options: TVEpisodeAppendOption = [
            .credits, .images, .videos,
            .translations, .externalIDs
        ]

        let value = options.queryValue
        let components = value.split(separator: ",")
        #expect(components.count == 5)
    }

}
