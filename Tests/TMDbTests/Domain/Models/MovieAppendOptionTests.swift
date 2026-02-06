//
//  MovieAppendOptionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieAppendOptionTests {

    @Test("queryValue for credits")
    func queryValueForCredits() {
        let option: MovieAppendOption = .credits

        #expect(option.queryValue == "credits")
    }

    @Test("queryValue for images")
    func queryValueForImages() {
        let option: MovieAppendOption = .images

        #expect(option.queryValue == "images")
    }

    @Test("queryValue for videos")
    func queryValueForVideos() {
        let option: MovieAppendOption = .videos

        #expect(option.queryValue == "videos")
    }

    @Test("queryValue for reviews")
    func queryValueForReviews() {
        let option: MovieAppendOption = .reviews

        #expect(option.queryValue == "reviews")
    }

    @Test("queryValue for recommendations")
    func queryValueForRecommendations() {
        let option: MovieAppendOption = .recommendations

        #expect(option.queryValue == "recommendations")
    }

    @Test("queryValue for similar")
    func queryValueForSimilar() {
        let option: MovieAppendOption = .similar

        #expect(option.queryValue == "similar")
    }

    @Test("queryValue for releaseDates")
    func queryValueForReleaseDates() {
        let option: MovieAppendOption = .releaseDates

        #expect(option.queryValue == "release_dates")
    }

    @Test("queryValue for alternativeTitles")
    func queryValueForAlternativeTitles() {
        let option: MovieAppendOption = .alternativeTitles

        #expect(option.queryValue == "alternative_titles")
    }

    @Test("queryValue for translations")
    func queryValueForTranslations() {
        let option: MovieAppendOption = .translations

        #expect(option.queryValue == "translations")
    }

    @Test("queryValue for keywords")
    func queryValueForKeywords() {
        let option: MovieAppendOption = .keywords

        #expect(option.queryValue == "keywords")
    }

    @Test("queryValue for watchProviders")
    func queryValueForWatchProviders() {
        let option: MovieAppendOption = .watchProviders

        #expect(option.queryValue == "watch/providers")
    }

    @Test("queryValue for externalIDs")
    func queryValueForExternalIDs() {
        let option: MovieAppendOption = .externalIDs

        #expect(option.queryValue == "external_ids")
    }

    @Test("queryValue for lists")
    func queryValueForLists() {
        let option: MovieAppendOption = .lists

        #expect(option.queryValue == "lists")
    }

    @Test("queryValue for changes")
    func queryValueForChanges() {
        let option: MovieAppendOption = .changes

        #expect(option.queryValue == "changes")
    }

    @Test("queryValue for multiple options")
    func queryValueForMultipleOptions() {
        let options: MovieAppendOption = [.credits, .images]

        let value = options.queryValue
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryValue for all options")
    func queryValueForAllOptions() {
        let options: MovieAppendOption = [
            .credits, .images, .videos, .reviews,
            .recommendations, .similar, .releaseDates,
            .alternativeTitles, .translations, .keywords,
            .watchProviders, .externalIDs, .lists, .changes
        ]

        let value = options.queryValue
        let components = value.split(separator: ",")
        #expect(components.count == 14)
    }

}
