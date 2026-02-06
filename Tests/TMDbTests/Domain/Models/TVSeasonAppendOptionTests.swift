//
//  TVSeasonAppendOptionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeasonAppendOptionTests {

    @Test("queryValue for credits")
    func queryValueForCredits() {
        let option: TVSeasonAppendOption = .credits

        #expect(option.queryValue == "credits")
    }

    @Test("queryValue for aggregateCredits")
    func queryValueForAggregateCredits() {
        let option: TVSeasonAppendOption = .aggregateCredits

        #expect(option.queryValue == "aggregate_credits")
    }

    @Test("queryValue for images")
    func queryValueForImages() {
        let option: TVSeasonAppendOption = .images

        #expect(option.queryValue == "images")
    }

    @Test("queryValue for videos")
    func queryValueForVideos() {
        let option: TVSeasonAppendOption = .videos

        #expect(option.queryValue == "videos")
    }

    @Test("queryValue for translations")
    func queryValueForTranslations() {
        let option: TVSeasonAppendOption = .translations

        #expect(option.queryValue == "translations")
    }

    @Test("queryValue for watchProviders")
    func queryValueForWatchProviders() {
        let option: TVSeasonAppendOption = .watchProviders

        #expect(option.queryValue == "watch/providers")
    }

    @Test("queryValue for externalIDs")
    func queryValueForExternalIDs() {
        let option: TVSeasonAppendOption = .externalIDs

        #expect(option.queryValue == "external_ids")
    }

    @Test("queryValue for multiple options")
    func queryValueForMultipleOptions() {
        let options: TVSeasonAppendOption = [.credits, .images]

        let value = options.queryValue
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryValue for all options")
    func queryValueForAllOptions() {
        let options: TVSeasonAppendOption = [
            .credits, .aggregateCredits, .images, .videos,
            .translations, .watchProviders, .externalIDs
        ]

        let value = options.queryValue
        let components = value.split(separator: ",")
        #expect(components.count == 7)
    }

}
