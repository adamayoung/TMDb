//
//  SearchPlan.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A structured interpretation of a natural-language search prompt.
///
/// A `SearchPlan` is produced from a prompt on device — deterministically via
/// Apple's Natural Language framework, or, for fuzzier prompts on devices with
/// Apple Intelligence, by an on-device language model — and then executed
/// deterministically against TMDb services. It contains natural-language
/// operands (names, symbolic dates) rather than TMDb identifiers, which are
/// resolved during execution.
///
public struct SearchPlan: Sendable, Equatable {

    ///
    /// The kind of search the prompt describes.
    ///
    /// This vocabulary grows as the planner learns to recognise new kinds of
    /// request, so it is a struct with static members rather than an enum: a new
    /// intent can ship in a **minor** release without breaking a `switch` you
    /// have already written. Match the intents you handle and cover the rest with
    /// a `default:`.
    ///
    public struct Intent: Sendable, Equatable, Hashable, CustomStringConvertible {

        enum Kind: Hashable {
            case find
            case browse
            case byPerson
            case castOf
            case crewRole
            case similar
            case list
            case mood
        }

        let kind: Kind

        private init(kind: Kind) {
            self.kind = kind
        }

        /// Look up a title or name directly (a bare query, like a normal search).
        public static let find = Intent(kind: .find)

        /// Browse/filter movies or TV series by attributes.
        public static let browse = Intent(kind: .browse)

        /// Movies or TV series featuring particular people.
        public static let byPerson = Intent(kind: .byPerson)

        /// The cast of a particular title.
        public static let castOf = Intent(kind: .castOf)

        /// People in a particular crew role for a title.
        public static let crewRole = Intent(kind: .crewRole)

        /// Titles similar to a particular title.
        public static let similar = Intent(kind: .similar)

        /// A top-level curated list (trending, popular, and so on).
        public static let list = Intent(kind: .list)

        /// A subjective mood mapped to genres.
        public static let mood = Intent(kind: .mood)

        /// A textual representation of the intent.
        public var description: String {
            switch kind {
            case .find: "find"
            case .browse: "browse"
            case .byPerson: "byPerson"
            case .castOf: "castOf"
            case .crewRole: "crewRole"
            case .similar: "similar"
            case .list: "list"
            case .mood: "mood"
            }
        }

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
    /// TMDb adds curated lists over time, so this is a struct with static members
    /// rather than an enum: a new list kind can ship in a **minor** release
    /// without breaking a `switch` you have already written. Match the kinds you
    /// handle and cover the rest with a `default:`.
    ///
    public struct ListKind: Sendable, Equatable, Hashable, CustomStringConvertible {

        enum Kind: Hashable {
            case trending
            case popular
            case topRated
            case nowPlaying
            case upcoming
            case airingToday
        }

        let kind: Kind

        private init(kind: Kind) {
            self.kind = kind
        }

        /// Trending titles.
        public static let trending = ListKind(kind: .trending)

        /// Popular titles.
        public static let popular = ListKind(kind: .popular)

        /// Top-rated titles.
        public static let topRated = ListKind(kind: .topRated)

        /// Movies now playing in cinemas.
        public static let nowPlaying = ListKind(kind: .nowPlaying)

        /// Upcoming movie releases.
        public static let upcoming = ListKind(kind: .upcoming)

        /// TV series airing today.
        public static let airingToday = ListKind(kind: .airingToday)

        /// A textual representation of the list kind.
        public var description: String {
            switch kind {
            case .trending: "trending"
            case .popular: "popular"
            case .topRated: "topRated"
            case .nowPlaying: "nowPlaying"
            case .upcoming: "upcoming"
            case .airingToday: "airingToday"
            }
        }

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
    /// - Note: For the ``Intent/byPerson`` intent this narrows results to titles
    ///   where the person had a crew credit, but not to the specific job — TMDb's
    ///   discover `with_crew` filter has no job dimension. The ``Intent/crewRole``
    ///   intent (with a `title`) filters by the exact job.
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
        self.moodTerm = moodTerm
        self.date = date
        self.runtimeMaxMinutes = runtimeMaxMinutes
        self.minRating = minRating
        self.list = list
    }

}
