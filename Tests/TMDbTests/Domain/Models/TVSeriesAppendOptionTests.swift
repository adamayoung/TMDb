//
//  TVSeriesAppendOptionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesAppendOptionTests {

    @Test("queryValue for credits")
    func queryValueForCredits() {
        let option: TVSeriesAppendOption = .credits

        #expect(option.queryValue == "credits")
    }

    @Test("queryValue for aggregateCredits")
    func queryValueForAggregateCredits() {
        let option: TVSeriesAppendOption = .aggregateCredits

        #expect(option.queryValue == "aggregate_credits")
    }

    @Test("queryValue for images")
    func queryValueForImages() {
        let option: TVSeriesAppendOption = .images

        #expect(option.queryValue == "images")
    }

    @Test("queryValue for videos")
    func queryValueForVideos() {
        let option: TVSeriesAppendOption = .videos

        #expect(option.queryValue == "videos")
    }

    @Test("queryValue for reviews")
    func queryValueForReviews() {
        let option: TVSeriesAppendOption = .reviews

        #expect(option.queryValue == "reviews")
    }

    @Test("queryValue for recommendations")
    func queryValueForRecommendations() {
        let option: TVSeriesAppendOption = .recommendations

        #expect(option.queryValue == "recommendations")
    }

    @Test("queryValue for similar")
    func queryValueForSimilar() {
        let option: TVSeriesAppendOption = .similar

        #expect(option.queryValue == "similar")
    }

    @Test("queryValue for contentRatings")
    func queryValueForContentRatings() {
        let option: TVSeriesAppendOption = .contentRatings

        #expect(option.queryValue == "content_ratings")
    }

    @Test("queryValue for alternativeTitles")
    func queryValueForAlternativeTitles() {
        let option: TVSeriesAppendOption = .alternativeTitles

        #expect(option.queryValue == "alternative_titles")
    }

    @Test("queryValue for translations")
    func queryValueForTranslations() {
        let option: TVSeriesAppendOption = .translations

        #expect(option.queryValue == "translations")
    }

    @Test("queryValue for keywords")
    func queryValueForKeywords() {
        let option: TVSeriesAppendOption = .keywords

        #expect(option.queryValue == "keywords")
    }

    @Test("queryValue for watchProviders")
    func queryValueForWatchProviders() {
        let option: TVSeriesAppendOption = .watchProviders

        #expect(option.queryValue == "watch/providers")
    }

    @Test("queryValue for externalIDs")
    func queryValueForExternalIDs() {
        let option: TVSeriesAppendOption = .externalIDs

        #expect(option.queryValue == "external_ids")
    }

    @Test("queryValue for screenedTheatrically")
    func queryValueForScreenedTheatrically() {
        let option: TVSeriesAppendOption = .screenedTheatrically

        #expect(option.queryValue == "screened_theatrically")
    }

    @Test("queryValue for episodeGroups")
    func queryValueForEpisodeGroups() {
        let option: TVSeriesAppendOption = .episodeGroups

        #expect(option.queryValue == "episode_groups")
    }

    @Test("queryValue for lists")
    func queryValueForLists() {
        let option: TVSeriesAppendOption = .lists

        #expect(option.queryValue == "lists")
    }

    @Test("queryValue for changes")
    func queryValueForChanges() {
        let option: TVSeriesAppendOption = .changes

        #expect(option.queryValue == "changes")
    }

    @Test("queryValue for multiple options")
    func queryValueForMultipleOptions() {
        let options: TVSeriesAppendOption = [.credits, .images]

        let value = options.queryValue
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryValue for all options")
    func queryValueForAllOptions() {
        let options: TVSeriesAppendOption = [
            .credits, .aggregateCredits, .images, .videos,
            .reviews, .recommendations, .similar, .contentRatings,
            .alternativeTitles, .translations, .keywords,
            .watchProviders, .externalIDs, .screenedTheatrically,
            .episodeGroups, .lists, .changes
        ]

        let value = options.queryValue
        let components = value.split(separator: ",")
        #expect(components.count == 17)
    }

}
