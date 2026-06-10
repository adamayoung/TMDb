//
//  ToolArgumentEnums.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A media type a language model can request when searching.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    @Generable
    enum SearchMediaType {
        /// A movie.
        case movie
        /// A TV series.
        case tvSeries
        /// A person.
        case person
    }

    ///
    /// A media type a language model can request when fetching trending items.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    @Generable
    enum TrendingMediaType {
        /// Trending movies.
        case movie
        /// Trending TV series.
        case tvSeries
        /// Trending people.
        case person
    }

    ///
    /// The time window for a trending request.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    @Generable
    enum TrendingWindow {
        /// The trending items over the last day.
        case day
        /// The trending items over the last week.
        case week

        /// The matching domain time-window filter.
        var filterType: TrendingTimeWindowFilterType {
            switch self {
            case .day: .day
            case .week: .week
            }
        }
    }

    ///
    /// A media type a language model can request when fetching watch providers.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    @Generable
    enum WatchMediaType {
        /// A movie.
        case movie
        /// A TV series.
        case tvSeries
    }

    ///
    /// A movie genre a language model can filter by when discovering movies.
    ///
    /// Each case maps to its stable TMDb genre identifier, so no network lookup is
    /// needed to resolve a genre name.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    @Generable
    enum MovieGenre {
        /// Action.
        case action
        /// Adventure.
        case adventure
        /// Animation.
        case animation
        /// Comedy.
        case comedy
        /// Crime.
        case crime
        /// Documentary.
        case documentary
        /// Drama.
        case drama
        /// Family.
        case family
        /// Fantasy.
        case fantasy
        /// History.
        case history
        /// Horror.
        case horror
        /// Music.
        case music
        /// Mystery.
        case mystery
        /// Romance.
        case romance
        /// Science fiction.
        case scienceFiction
        /// Thriller.
        case thriller
        /// War.
        case war
        /// Western.
        case western

        /// The stable TMDb genre identifier for this genre.
        var genreID: Genre.ID {
            switch self {
            case .action: 28
            case .adventure: 12
            case .animation: 16
            case .comedy: 35
            case .crime: 80
            case .documentary: 99
            case .drama: 18
            case .family: 10751
            case .fantasy: 14
            case .history: 36
            case .horror: 27
            case .music: 10402
            case .mystery: 9648
            case .romance: 10749
            case .scienceFiction: 878
            case .thriller: 53
            case .war: 10752
            case .western: 37
            }
        }
    }
#endif
