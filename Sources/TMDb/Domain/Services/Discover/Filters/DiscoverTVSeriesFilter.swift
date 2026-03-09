//
//  DiscoverTVSeriesFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A filter for discovering TV series.
///
public struct DiscoverTVSeriesFilter: Sendable {

    ///
    /// The original language of the TV series.
    ///
    public let originalLanguage: String?

    ///
    /// A list of genre identifiers associated with the TV series.
    ///
    public let genres: [Genre.ID]?

    ///
    /// A list of genre identifiers to exclude.
    ///
    public let withoutGenres: [Genre.ID]?

    ///
    /// The first air date year.
    ///
    public let firstAirDateYear: Int?

    ///
    /// Minimum first air date.
    ///
    public let firstAirDateMin: Date?

    ///
    /// Maximum first air date.
    ///
    public let firstAirDateMax: Date?

    ///
    /// Minimum episode air date.
    ///
    public let airDateMin: Date?

    ///
    /// Maximum episode air date.
    ///
    public let airDateMax: Date?

    ///
    /// Minimum vote average score.
    ///
    public let voteAverageMin: Double?

    ///
    /// Maximum vote average score.
    ///
    public let voteAverageMax: Double?

    ///
    /// Minimum number of votes.
    ///
    public let voteCountMin: Int?

    ///
    /// Maximum number of votes.
    ///
    public let voteCountMax: Int?

    ///
    /// A list of network identifiers.
    ///
    public let networks: [Network.ID]?

    ///
    /// A list of production company identifiers.
    ///
    public let companies: [Company.ID]?

    ///
    /// A list of keyword identifiers to include.
    ///
    public let keywords: [Keyword.ID]?

    ///
    /// A list of keyword identifiers to exclude.
    ///
    public let withoutKeywords: [Keyword.ID]?

    ///
    /// Minimum runtime in minutes.
    ///
    public let runtimeMin: Int?

    ///
    /// Maximum runtime in minutes.
    ///
    public let runtimeMax: Int?

    ///
    /// Include adult content.
    ///
    public let includeAdult: Bool?

    ///
    /// A list of watch provider identifiers.
    ///
    public let watchProviders: [WatchProvider.ID]?

    ///
    /// ISO-3166-1 watch region code.
    ///
    public let watchRegion: String?

    ///
    /// Filter by origin country (ISO-3166-1).
    ///
    public let withOriginCountry: String?

    ///
    /// TV series status filter.
    ///
    public let withStatus: [TVSeriesStatus]?

    ///
    /// Show type filter.
    ///
    public let withType: [TVSeriesType]?

    ///
    /// A list of production company identifiers to exclude.
    ///
    public let withoutCompanies: [Company.ID]?

    ///
    /// Filter by watch monetization type.
    ///
    public let watchMonetizationTypes: [WatchMonetizationType]?

    ///
    /// Filter for TV series that have been screened theatrically.
    ///
    public let screenedTheatrically: Bool?

    ///
    /// A list of Person identifiers to filter by.
    ///
    public let withPeople: [Person.ID]?

    ///
    /// Creates a discover TV series filter.
    ///
    /// - Parameters:
    ///   - originalLanguage: The original language of the TV series.
    ///   - genres: A list of genre identifiers associated with the
    ///     TV series.
    ///   - withoutGenres: A list of genre identifiers to exclude.
    ///   - firstAirDateYear: The first air date year.
    ///   - firstAirDateMin: Minimum first air date.
    ///   - firstAirDateMax: Maximum first air date.
    ///   - airDateMin: Minimum episode air date.
    ///   - airDateMax: Maximum episode air date.
    ///   - voteAverageMin: Minimum vote average score.
    ///   - voteAverageMax: Maximum vote average score.
    ///   - voteCountMin: Minimum number of votes.
    ///   - voteCountMax: Maximum number of votes.
    ///   - networks: A list of network identifiers.
    ///   - companies: A list of production company identifiers.
    ///   - keywords: A list of keyword identifiers to include.
    ///   - withoutKeywords: A list of keyword identifiers to exclude.
    ///   - runtimeMin: Minimum runtime in minutes.
    ///   - runtimeMax: Maximum runtime in minutes.
    ///   - includeAdult: Include adult content.
    ///   - watchProviders: A list of watch provider identifiers.
    ///   - watchRegion: ISO-3166-1 watch region code.
    ///   - withOriginCountry: Filter by origin country.
    ///   - withStatus: TV series status filter.
    ///   - withType: Show type filter.
    ///   - withoutCompanies: Production company identifiers to exclude.
    ///   - watchMonetizationTypes: Filter by monetization type.
    ///   - screenedTheatrically: Filter for theatrically screened
    ///     series.
    ///   - withPeople: A list of Person identifiers to filter by.
    ///
    public init(
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil,
        withoutGenres: [Genre.ID]? = nil,
        firstAirDateYear: Int? = nil,
        firstAirDateMin: Date? = nil,
        firstAirDateMax: Date? = nil,
        airDateMin: Date? = nil,
        airDateMax: Date? = nil,
        voteAverageMin: Double? = nil,
        voteAverageMax: Double? = nil,
        voteCountMin: Int? = nil,
        voteCountMax: Int? = nil,
        networks: [Network.ID]? = nil,
        companies: [Company.ID]? = nil,
        keywords: [Keyword.ID]? = nil,
        withoutKeywords: [Keyword.ID]? = nil,
        runtimeMin: Int? = nil,
        runtimeMax: Int? = nil,
        includeAdult: Bool? = nil,
        watchProviders: [WatchProvider.ID]? = nil,
        watchRegion: String? = nil,
        withOriginCountry: String? = nil,
        withStatus: [TVSeriesStatus]? = nil,
        withType: [TVSeriesType]? = nil,
        withoutCompanies: [Company.ID]? = nil,
        watchMonetizationTypes: [WatchMonetizationType]? = nil,
        screenedTheatrically: Bool? = nil,
        withPeople: [Person.ID]? = nil
    ) {
        self.originalLanguage = originalLanguage
        self.genres = genres
        self.withoutGenres = withoutGenres
        self.firstAirDateYear = firstAirDateYear
        self.firstAirDateMin = firstAirDateMin
        self.firstAirDateMax = firstAirDateMax
        self.airDateMin = airDateMin
        self.airDateMax = airDateMax
        self.voteAverageMin = voteAverageMin
        self.voteAverageMax = voteAverageMax
        self.voteCountMin = voteCountMin
        self.voteCountMax = voteCountMax
        self.networks = networks
        self.companies = companies
        self.keywords = keywords
        self.withoutKeywords = withoutKeywords
        self.runtimeMin = runtimeMin
        self.runtimeMax = runtimeMax
        self.includeAdult = includeAdult
        self.watchProviders = watchProviders
        self.watchRegion = watchRegion
        self.withOriginCountry = withOriginCountry
        self.withStatus = withStatus
        self.withType = withType
        self.withoutCompanies = withoutCompanies
        self.watchMonetizationTypes = watchMonetizationTypes
        self.screenedTheatrically = screenedTheatrically
        self.withPeople = withPeople
    }

}
