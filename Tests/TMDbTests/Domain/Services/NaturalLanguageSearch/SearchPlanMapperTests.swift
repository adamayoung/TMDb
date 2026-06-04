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
            people: [String] = [],
            crewRole: String? = nil,
            genres: [String] = [],
            excludeTitles: [String] = [],
            companies: [String] = [],
            moodTerm: String? = nil,
            datePhrase: GeneratedDatePhrase? = nil,
            decade: Int? = nil,
            yearFrom: Int? = nil,
            yearTo: Int? = nil,
            runtimeMaxMinutes: Int? = nil,
            minRating: Double? = nil,
            list: GeneratedListKind? = nil
        ) -> GeneratedSearchPlan {
            GeneratedSearchPlan(
                intent: intent,
                isInScope: isInScope,
                mediaType: mediaType,
                title: title,
                people: people,
                crewRole: crewRole,
                genres: genres,
                excludeTitles: excludeTitles,
                companies: companies,
                moodTerm: moodTerm,
                datePhrase: datePhrase,
                decade: decade,
                yearFrom: yearFrom,
                yearTo: yearTo,
                runtimeMaxMinutes: runtimeMaxMinutes,
                minRating: minRating,
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

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps a lone upper-bound year")
        func mapsLoneYearTo() {
            let plan = SearchPlanMapper.map(generated(yearTo: 2010))
            #expect(plan.date == .exactYear(2010))
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("passes through people, crew role, exclusions, companies, mood, runtime, and rating")
        func passesThroughOperands() {
            let plan = SearchPlanMapper.map(
                generated(
                    people: ["Tom Hanks"],
                    crewRole: "Director",
                    excludeTitles: ["Star Trek"],
                    companies: ["Pixar"],
                    moodTerm: "feel-good",
                    runtimeMaxMinutes: 120,
                    minRating: 7.5
                )
            )

            #expect(plan.people == ["Tom Hanks"])
            #expect(plan.crewRole == "Director")
            #expect(plan.excludeTitles == ["Star Trek"])
            #expect(plan.companies == ["Pixar"])
            #expect(plan.moodTerm == "feel-good")
            #expect(plan.runtimeMaxMinutes == 120)
            #expect(plan.minRating == 7.5)
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps every intent arm")
        func mapsEveryIntent() {
            let cases: [(GeneratedIntent, SearchPlan.Intent)] = [
                (.find, .find), (.browse, .browse), (.filmography, .byPerson),
                (.castOf, .castOf), (.crewRole, .crewRole), (.similar, .similar),
                (.list, .list), (.mood, .mood)
            ]
            for (input, expected) in cases {
                #expect(SearchPlanMapper.map(generated(intent: input)).intent == expected)
            }
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps every media type")
        func mapsEveryMediaType() {
            #expect(SearchPlanMapper.map(generated(mediaType: .movie)).mediaType == .movie)
            #expect(SearchPlanMapper.map(generated(mediaType: .tv)).mediaType == .tv)
            #expect(SearchPlanMapper.map(generated(mediaType: .person)).mediaType == .person)
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps every list kind")
        func mapsEveryListKind() {
            let cases: [(GeneratedListKind, SearchPlan.ListKind)] = [
                (.trending, .trending), (.popular, .popular), (.topRated, .topRated),
                (.nowPlaying, .nowPlaying), (.upcoming, .upcoming), (.airingToday, .airingToday)
            ]
            for (input, expected) in cases {
                #expect(SearchPlanMapper.map(generated(intent: .list, list: input)).list == expected)
            }
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps the recent and last-ten-years date phrases")
        func mapsRemainingDatePhrases() {
            #expect(SearchPlanMapper.map(generated(datePhrase: .recent)).date == .recent)
            #expect(SearchPlanMapper.map(generated(datePhrase: .lastTenYears)).date == .lastNYears(10))
        }

        @available(iOS 26, macOS 26, visionOS 26, *)
        @Test("maps a lone lower-bound year to an exact year")
        func mapsLoneYearFrom() {
            #expect(SearchPlanMapper.map(generated(yearFrom: 1999)).date == .exactYear(1999))
        }

    }
#endif
