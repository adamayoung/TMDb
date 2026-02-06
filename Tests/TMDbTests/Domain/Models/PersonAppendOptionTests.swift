//
//  PersonAppendOptionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PersonAppendOptionTests {

    @Test("queryValue for movieCredits")
    func queryValueForMovieCredits() {
        let option: PersonAppendOption = .movieCredits

        #expect(option.queryValue == "movie_credits")
    }

    @Test("queryValue for tvCredits")
    func queryValueForTVCredits() {
        let option: PersonAppendOption = .tvCredits

        #expect(option.queryValue == "tv_credits")
    }

    @Test("queryValue for combinedCredits")
    func queryValueForCombinedCredits() {
        let option: PersonAppendOption = .combinedCredits

        #expect(option.queryValue == "combined_credits")
    }

    @Test("queryValue for images")
    func queryValueForImages() {
        let option: PersonAppendOption = .images

        #expect(option.queryValue == "images")
    }

    @Test("queryValue for taggedImages")
    func queryValueForTaggedImages() {
        let option: PersonAppendOption = .taggedImages

        #expect(option.queryValue == "tagged_images")
    }

    @Test("queryValue for translations")
    func queryValueForTranslations() {
        let option: PersonAppendOption = .translations

        #expect(option.queryValue == "translations")
    }

    @Test("queryValue for externalIDs")
    func queryValueForExternalIDs() {
        let option: PersonAppendOption = .externalIDs

        #expect(option.queryValue == "external_ids")
    }

    @Test("queryValue for changes")
    func queryValueForChanges() {
        let option: PersonAppendOption = .changes

        #expect(option.queryValue == "changes")
    }

    @Test("queryValue for multiple options")
    func queryValueForMultipleOptions() {
        let options: PersonAppendOption = [.movieCredits, .images]

        let value = options.queryValue
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["movie_credits", "images"])
    }

    @Test("queryValue for all options")
    func queryValueForAllOptions() {
        let options: PersonAppendOption = [
            .movieCredits, .tvCredits, .combinedCredits, .images,
            .taggedImages, .translations, .externalIDs, .changes
        ]

        let value = options.queryValue
        let components = value.split(separator: ",")
        #expect(components.count == 8)
    }

}
