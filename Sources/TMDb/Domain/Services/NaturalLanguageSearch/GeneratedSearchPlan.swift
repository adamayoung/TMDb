//
//  GeneratedSearchPlan.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels)
    import Foundation
    import FoundationModels

    ///
    /// The guided-generation mirror of ``SearchPlan``.
    ///
    /// This type exists only so the on-device model can produce a structured plan.
    /// It is mapped to the un-gated ``SearchPlan`` immediately, keeping
    /// Foundation Models out of the rest of the feature.
    ///
    @available(iOS 26, macOS 26, visionOS 26, *)
    @Generable
    struct GeneratedSearchPlan {

        @Guide(description: "The kind of request the prompt describes.")
        let intent: GeneratedIntent

        @Guide(description: "True only if the request is about movies, TV series, or people.")
        let isInScope: Bool

        @Guide(description: "Whether the request is about movies, TV series, or people.")
        let mediaType: GeneratedMediaType?

        @Guide(description: "A movie or TV series title mentioned, if any.")
        let title: String?

        @Guide(description: "Only person names the user literally typed. "
            + "Never the cast or actors of a title.")
        let people: [String]

        @Guide(description: "A crew role mentioned, for example Director.")
        let crewRole: String?

        @Guide(description: "Genre names mentioned, if any.")
        let genres: [String]

        @Guide(description: "Titles or franchises to exclude.")
        let excludeTitles: [String]

        @Guide(description: "Production company names mentioned, if any.")
        let companies: [String]

        @Guide(description: "A subjective mood word such as feel-good or cozy, if any.")
        let moodTerm: String?

        @Guide(description: "A relative time phrase, if the prompt uses one.")
        let datePhrase: GeneratedDatePhrase?

        @Guide(description: "A decade mentioned, given as its first year such as 1990.")
        let decade: Int?

        @Guide(description: "The earliest explicit year mentioned.")
        let yearFrom: Int?

        @Guide(description: "The latest explicit year mentioned.")
        let yearTo: Int?

        @Guide(description: "A maximum runtime in minutes.")
        let runtimeMaxMinutes: Int?

        @Guide(description: "A minimum average rating from 0 to 10.")
        let minRating: Double?

        @Guide(description: "The curated list requested, when the intent is a list.")
        let list: GeneratedListKind?

    }

    @available(iOS 26, macOS 26, visionOS 26, *)
    @Generable
    enum GeneratedIntent {
        case find, browse, filmography, castOf, crewRole, similar, list, mood
    }

    @available(iOS 26, macOS 26, visionOS 26, *)
    @Generable
    enum GeneratedMediaType {
        case movie, tv, person
    }

    @available(iOS 26, macOS 26, visionOS 26, *)
    @Generable
    enum GeneratedListKind {
        case trending, popular, topRated, nowPlaying, upcoming, airingToday
    }

    @available(iOS 26, macOS 26, visionOS 26, *)
    @Generable
    enum GeneratedDatePhrase {
        case thisYear, recent, lastFiveYears, lastTenYears
    }
#endif
