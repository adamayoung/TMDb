//
//  SearchPlanVocabularyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDbIntelligence

@Suite("SearchPlan vocabulary")
struct SearchPlanVocabularyTests {

    private static let allIntents: [(SearchPlan.Intent, String)] = [
        (.find, "find"),
        (.browse, "browse"),
        (.byPerson, "byPerson"),
        (.castOf, "castOf"),
        (.crewRole, "crewRole"),
        (.similar, "similar"),
        (.list, "list"),
        (.mood, "mood")
    ]

    private static let allListKinds: [(SearchPlan.ListKind, String)] = [
        (.trending, "trending"),
        (.popular, "popular"),
        (.topRated, "topRated"),
        (.nowPlaying, "nowPlaying"),
        (.upcoming, "upcoming"),
        (.airingToday, "airingToday")
    ]

    /// 1. every intent has a distinct, stable description
    @Test("every intent has a distinct, stable description")
    func everyIntentHasADistinctStableDescription() {
        for (intent, description) in Self.allIntents {
            #expect(intent.description == description)
            // Interpolation parity with the enum this replaced — a struct's
            // default interpolation would be a reflection dump.
            #expect(description == "\(intent)")
        }

        #expect(Set(Self.allIntents.map(\.1)).count == Self.allIntents.count)
    }

    /// 2. every list kind has a distinct, stable description
    @Test("every list kind has a distinct, stable description")
    func everyListKindHasADistinctStableDescription() {
        for (kind, description) in Self.allListKinds {
            #expect(kind.description == description)
            #expect(description == "\(kind)")
        }

        #expect(Set(Self.allListKinds.map(\.1)).count == Self.allListKinds.count)
    }

    /// 3. an intent equals itself and differs from every other intent
    @Test("an intent equals itself and differs from every other intent")
    func intentEqualityIsDiscriminating() {
        for (outerIndex, (lhs, _)) in Self.allIntents.enumerated() {
            for (innerIndex, (rhs, _)) in Self.allIntents.enumerated() {
                if outerIndex == innerIndex {
                    #expect(lhs == rhs)
                } else {
                    #expect(lhs != rhs)
                }
            }
        }
    }

    /// 4. pattern matching an intent still works
    @Test("pattern matching an intent still works")
    func patternMatchingAnIntent() {
        let plan = SearchPlan(intent: .find)

        // `if case` against a static member resolves through the stdlib `~=` for
        // Equatable, exactly as it did for an enum case.
        if case .find = plan.intent {
            // Expected.
        } else {
            Issue.record("expected .find to match")
        }

        if case .browse = plan.intent {
            Issue.record("expected .browse not to match")
        }

        switch plan.intent {
        case .find: break
        default: Issue.record("expected .find in a switch with a default")
        }
    }

    /// 5. the public initializer round-trips an intent
    @Test("the public initializer round-trips an intent")
    func publicInitializerRoundTripsAnIntent() {
        #expect(SearchPlan(intent: .find).intent == .find)
        #expect(SearchPlan(intent: .list, list: .popular).intent == .list)
        #expect(SearchPlan(intent: .list, list: .popular).list == .popular)
    }

    /// 6. an intent works as a dictionary key and a Set member
    @Test("an intent works as a dictionary key and a Set member")
    func intentIsUsableAsAKeyAndSetMember() {
        // A payload-free enum is implicitly Hashable; the struct must keep that or
        // consumer code keying off an intent stops compiling.
        let labels: [SearchPlan.Intent: String] = [
            .find: "find",
            .browse: "browse"
        ]

        #expect(labels[.find] == "find")
        #expect(labels[.browse] == "browse")
        #expect(labels[.mood] == nil)

        let intents: Set<SearchPlan.Intent> = [.find, .find, .browse]
        #expect(intents.count == 2)

        let kinds: Set<SearchPlan.ListKind> = [.popular, .popular, .trending]
        #expect(kinds.count == 2)
    }

}
