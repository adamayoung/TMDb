//
//  SearchPlanMapper.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels)
    import Foundation

    ///
    /// Maps a guided-generation ``GeneratedSearchPlan`` to a ``SearchPlan``.
    ///
    /// The mapping is pure and deterministic, so it can be unit tested without the
    /// model.
    ///
    @available(iOS 26, macOS 26, visionOS 26, *)
    enum SearchPlanMapper {

        static func map(_ generated: GeneratedSearchPlan) -> SearchPlan {
            SearchPlan(
                intent: mapIntent(generated.intent),
                isInScope: generated.isInScope,
                mediaType: generated.mediaType.map(mapMediaType),
                title: generated.title,
                people: generated.people,
                crewRole: generated.crewRole,
                genres: generated.genres,
                excludeTitles: generated.excludeTitles,
                companies: generated.companies,
                networks: [],
                moodTerm: generated.moodTerm,
                date: mapDate(generated),
                runtimeMaxMinutes: generated.runtimeMaxMinutes,
                minRating: generated.minRating,
                list: generated.list.map(mapListKind)
            )
        }

        private static func mapIntent(_ intent: GeneratedIntent) -> SearchPlan.Intent {
            switch intent {
            case .find: .find
            case .browse: .browse
            case .byPerson: .byPerson
            case .castOf: .castOf
            case .crewRole: .crewRole
            case .similar: .similar
            case .list: .list
            case .mood: .mood
            }
        }

        private static func mapMediaType(_ mediaType: GeneratedMediaType) -> SearchPlan.MediaType {
            switch mediaType {
            case .movie: .movie
            case .tv: .tv
            case .person: .person
            }
        }

        private static func mapListKind(_ kind: GeneratedListKind) -> SearchPlan.ListKind {
            switch kind {
            case .trending: .trending
            case .popular: .popular
            case .topRated: .topRated
            case .nowPlaying: .nowPlaying
            case .upcoming: .upcoming
            case .airingToday: .airingToday
            }
        }

        private static func mapDate(_ generated: GeneratedSearchPlan) -> SearchPlan.RelativeDate? {
            if let phrase = generated.datePhrase {
                switch phrase {
                case .thisYear: return .thisYear
                case .recent: return .recent
                case .lastFiveYears: return .lastNYears(5)
                case .lastTenYears: return .lastNYears(10)
                }
            }

            if let decade = generated.decade {
                return .decade(decade)
            }

            if let start = generated.yearFrom, let end = generated.yearTo {
                return start == end ? .exactYear(start) : .between(start: start, end: end)
            }

            if let from = generated.yearFrom {
                return .exactYear(from)
            }

            return nil
        }

    }
#endif
