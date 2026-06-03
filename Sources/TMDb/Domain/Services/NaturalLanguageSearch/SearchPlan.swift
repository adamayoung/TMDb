//
//  SearchPlan.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A structured interpretation of a natural-language search prompt.
///
/// A `SearchPlan` is produced from a prompt by an on-device language model and
/// then executed deterministically against TMDb services. It contains
/// natural-language operands (names, symbolic dates) rather than TMDb
/// identifiers, which are resolved during execution.
///
public struct SearchPlan: Sendable, Equatable {

    ///
    /// The kind of search the prompt describes.
    ///
    public enum Intent: Sendable, Equatable {

        /// Look up a title or name directly (a bare query, like a normal search).
        case find

        /// Browse/filter movies or TV series by attributes.
        case browse

        /// Movies or TV series featuring particular people.
        case byPerson

        /// The cast of a particular title.
        case castOf

        /// People in a particular crew role for a title.
        case crewRole

        /// Titles similar to a particular title.
        case similar

        /// A top-level curated list (trending, popular, and so on).
        case list

        /// A subjective mood mapped to genres.
        case mood
    }

    ///
    /// Whether the prompt is about movies, TV series, or people.
    ///
    public enum MediaType: Sendable, Equatable {

        /// Movies.
        case movie

        /// TV series.
        case tv

        /// People.
        case person
    }

    ///
    /// A symbolic date constraint resolved to concrete bounds during execution.
    ///
    /// The model emits symbolic values; date arithmetic is performed in code
    /// against an injected reference date so behaviour is deterministic.
    ///
    public enum RelativeDate: Sendable, Equatable {

        /// The current calendar year.
        case thisYear

        /// Recent releases (a small trailing window).
        case recent

        /// The last `n` years up to the reference date.
        case lastNYears(Int)

        /// A decade identified by its first year, for example `1990`.
        case decade(Int)

        /// A single, explicit year.
        case exactYear(Int)

        /// An inclusive range between two years.
        case between(start: Int, end: Int)
    }

    ///
    /// A top-level curated list.
    ///
    public enum ListKind: Sendable, Equatable {

        /// Trending titles.
        case trending

        /// Popular titles.
        case popular

        /// Top-rated titles.
        case topRated

        /// Movies now playing in cinemas.
        case nowPlaying

        /// Upcoming movie releases.
        case upcoming

        /// TV series airing today.
        case airingToday
    }

    ///
    /// The kind of search the prompt describes.
    ///
    public let intent: Intent

    ///
    /// Whether the prompt is in scope (about movies, TV series, or people).
    ///
    public let isInScope: Bool

    ///
    /// The media type the prompt concerns, if determinable.
    ///
    public let mediaType: MediaType?

    ///
    /// A movie or TV series title mentioned in the prompt.
    ///
    public let title: String?

    ///
    /// People named in the prompt, resolved to identifiers during execution.
    ///
    public let people: [String]

    ///
    /// A crew role named in the prompt, for example `"Director"`.
    ///
    public let crewRole: String?

    ///
    /// Genre names mentioned in the prompt.
    ///
    public let genres: [String]

    ///
    /// Titles or franchises to exclude from results.
    ///
    public let excludeTitles: [String]

    ///
    /// Production company names mentioned in the prompt.
    ///
    public let companies: [String]

    ///
    /// TV network names mentioned in the prompt.
    ///
    public let networks: [String]

    ///
    /// A subjective mood term mapped to genres during execution.
    ///
    public let moodTerm: String?

    ///
    /// A symbolic date constraint.
    ///
    public let date: RelativeDate?

    ///
    /// A maximum runtime in minutes.
    ///
    public let runtimeMaxMinutes: Int?

    ///
    /// A minimum average rating, from `0` to `10`.
    ///
    public let minRating: Double?

    ///
    /// The curated list requested, when `intent` is ``Intent/list``.
    ///
    public let list: ListKind?

    ///
    /// Creates a search plan.
    ///
    /// - Parameters:
    ///   - intent: The kind of search the prompt describes.
    ///   - isInScope: Whether the prompt is about movies, TV series, or people.
    ///   - mediaType: The media type the prompt concerns.
    ///   - title: A movie or TV series title mentioned in the prompt.
    ///   - people: People named in the prompt.
    ///   - crewRole: A crew role named in the prompt.
    ///   - genres: Genre names mentioned in the prompt.
    ///   - excludeTitles: Titles or franchises to exclude.
    ///   - companies: Production company names mentioned in the prompt.
    ///   - networks: TV network names mentioned in the prompt.
    ///   - moodTerm: A subjective mood term.
    ///   - date: A symbolic date constraint.
    ///   - runtimeMaxMinutes: A maximum runtime in minutes.
    ///   - minRating: A minimum average rating.
    ///   - list: The curated list requested.
    ///
    public init(
        intent: Intent,
        isInScope: Bool = true,
        mediaType: MediaType? = nil,
        title: String? = nil,
        people: [String] = [],
        crewRole: String? = nil,
        genres: [String] = [],
        excludeTitles: [String] = [],
        companies: [String] = [],
        networks: [String] = [],
        moodTerm: String? = nil,
        date: RelativeDate? = nil,
        runtimeMaxMinutes: Int? = nil,
        minRating: Double? = nil,
        list: ListKind? = nil
    ) {
        self.intent = intent
        self.isInScope = isInScope
        self.mediaType = mediaType
        self.title = title
        self.people = people
        self.crewRole = crewRole
        self.genres = genres
        self.excludeTitles = excludeTitles
        self.companies = companies
        self.networks = networks
        self.moodTerm = moodTerm
        self.date = date
        self.runtimeMaxMinutes = runtimeMaxMinutes
        self.minRating = minRating
        self.list = list
    }

}
