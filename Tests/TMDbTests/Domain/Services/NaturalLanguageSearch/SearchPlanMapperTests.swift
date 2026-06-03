//
//  SearchPlanMapperTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite("SearchPlanMapper")
    struct SearchPlanMapperTests {

        @available(iOS 26, macOS 26, visionOS 26, *)
        private func generated(
            intent: GeneratedIntent = .browse,
            isInScope: Bool = true,
            mediaType: GeneratedMediaType? = nil,
            title: String? = nil,
            genres: [String] = [],
            datePhrase: GeneratedDatePhrase? = nil,
            decade: Int? = nil,
            yearFrom: Int? = nil,
            yearTo: Int? = nil,
            list: GeneratedListKind? = nil
        ) -> GeneratedSearchPlan {
            GeneratedSearchPlan(
                intent: intent,
                isInScope: isInScope,
                mediaType: mediaType,
                title: title,
                people: [],
                crewRole: nil,
                genres: genres,
                excludeTitles: [],
                companies: [],
                moodTerm: nil,
                datePhrase: datePhrase,
                decade: decade,
                yearFrom: yearFrom,
                yearTo: yearTo,
                runtimeMaxMinutes: nil,
                minRating: nil,
                list: list
            )
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps intent, scope, media type, and genres")
        func mapsCoreFields() {
            let plan = SearchPlanMapper.map(
                generated(intent: .similar, isInScope: false, mediaType: .tv, title: "GoT", genres: ["Drama"])
            )

            #expect(plan.intent == .similar)
            #expect(plan.isInScope == false)
            #expect(plan.mediaType == .tv)
            #expect(plan.title == "GoT")
            #expect(plan.genres == ["Drama"])
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps a date phrase to a symbolic relative date")
        func mapsDatePhrase() {
            let plan = SearchPlanMapper.map(generated(datePhrase: .lastFiveYears))
            #expect(plan.date == .lastNYears(5))
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps a decade")
        func mapsDecade() {
            let plan = SearchPlanMapper.map(generated(decade: 1990))
            #expect(plan.date == .decade(1990))
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps an explicit year range")
        func mapsYearRange() {
            let plan = SearchPlanMapper.map(generated(yearFrom: 2010, yearTo: 2019))
            #expect(plan.date == .between(start: 2010, end: 2019))
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("prefers a date phrase over explicit years")
        func datePhraseTakesPrecedence() {
            let plan = SearchPlanMapper.map(generated(datePhrase: .thisYear, decade: 1990))
            #expect(plan.date == .thisYear)
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps a list kind")
        func mapsListKind() {
            let plan = SearchPlanMapper.map(generated(intent: .list, list: .topRated))
            #expect(plan.list == .topRated)
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps the find intent")
        func mapsFindIntent() {
            let plan = SearchPlanMapper.map(generated(intent: .find, title: "Fight Club"))
            #expect(plan.intent == .find)
            #expect(plan.title == "Fight Club")
        }

    }
#endif
