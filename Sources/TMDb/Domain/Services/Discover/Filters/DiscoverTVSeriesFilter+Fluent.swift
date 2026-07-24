//
//  DiscoverTVSeriesFilter+Fluent.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension DiscoverTVSeriesFilter {

    ///
    /// Returns a copy of the filter restricted to the given genres.
    ///
    /// - Parameters:
    ///   - genres: A list of genre identifiers to match.
    ///   - join: The logical operator used to combine the genres. Defaults to
    ///     ``DiscoverFilterJoin/and``.
    ///
    /// - Returns: A new filter with the genres applied. An empty `genres`
    ///   array is ignored and the filter is returned unchanged.
    ///
    func withGenres(
        _ genres: [Genre.ID],
        joinedBy join: DiscoverFilterJoin = .and
    ) -> Self {
        guard !genres.isEmpty else {
            return self
        }
        return copy(genres: genres, genresJoin: join)
    }

    ///
    /// Returns a copy of the filter excluding the given genres.
    ///
    /// - Parameter genres: A list of genre identifiers to exclude.
    ///
    /// - Returns: A new filter with the excluded genres applied. An empty
    ///   `genres` array is ignored and the filter is returned unchanged.
    ///
    func withoutGenres(_ genres: [Genre.ID]) -> Self {
        guard !genres.isEmpty else {
            return self
        }
        return copy(withoutGenres: genres)
    }

    ///
    /// Returns a copy of the filter restricted to the given keywords.
    ///
    /// - Parameters:
    ///   - keywords: A list of keyword identifiers to match.
    ///   - join: The logical operator used to combine the keywords. Defaults
    ///     to ``DiscoverFilterJoin/and``.
    ///
    /// - Returns: A new filter with the keywords applied. An empty `keywords`
    ///   array is ignored and the filter is returned unchanged.
    ///
    func withKeywords(
        _ keywords: [Keyword.ID],
        joinedBy join: DiscoverFilterJoin = .and
    ) -> Self {
        guard !keywords.isEmpty else {
            return self
        }
        return copy(keywords: keywords, keywordsJoin: join)
    }

    ///
    /// Returns a copy of the filter excluding the given keywords.
    ///
    /// - Parameter keywords: A list of keyword identifiers to exclude.
    ///
    /// - Returns: A new filter with the excluded keywords applied. An empty
    ///   `keywords` array is ignored and the filter is returned unchanged.
    ///
    func withoutKeywords(_ keywords: [Keyword.ID]) -> Self {
        guard !keywords.isEmpty else {
            return self
        }
        return copy(withoutKeywords: keywords)
    }

    ///
    /// Returns a copy of the filter restricted to the given networks.
    ///
    /// - Parameter networks: A list of network identifiers.
    ///
    /// - Returns: A new filter with the networks applied. An empty `networks`
    ///   array is ignored and the filter is returned unchanged.
    ///
    func withNetworks(_ networks: [Network.ID]) -> Self {
        guard !networks.isEmpty else {
            return self
        }
        return copy(networks: networks)
    }

    ///
    /// Returns a copy of the filter restricted to the given companies.
    ///
    /// - Parameter companies: A list of production company identifiers.
    ///
    /// - Returns: A new filter with the companies applied. An empty
    ///   `companies` array is ignored and the filter is returned unchanged.
    ///
    func withCompanies(_ companies: [Company.ID]) -> Self {
        guard !companies.isEmpty else {
            return self
        }
        return copy(companies: companies)
    }

    ///
    /// Returns a copy of the filter restricted to the given original language.
    ///
    /// - Parameter language: An ISO-639-1 language code.
    ///
    /// - Returns: A new filter with the original language applied. A blank
    ///   `language` is ignored and the filter is returned unchanged.
    ///
    func originalLanguage(_ language: String) -> Self {
        guard !language.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return self
        }
        return copy(originalLanguage: language)
    }

    ///
    /// Returns a copy of the filter restricted to the given first air date
    /// year.
    ///
    /// - Parameter year: The first air date year.
    ///
    /// - Returns: A new filter with the first air date year applied.
    ///
    func firstAirDateYear(_ year: Int) -> Self {
        copy(firstAirDateYear: year)
    }

    ///
    /// Returns a copy of the filter restricted to the given vote average range.
    ///
    /// - Parameter range: The inclusive vote average range.
    ///
    /// - Returns: A new filter with the vote average range applied.
    ///
    func voteAverage(in range: ClosedRange<Double>) -> Self {
        copy(voteAverageMin: range.lowerBound, voteAverageMax: range.upperBound)
    }

    ///
    /// Returns a copy of the filter restricted to the given vote count range.
    ///
    /// - Parameter range: The inclusive vote count range.
    ///
    /// - Returns: A new filter with the vote count range applied.
    ///
    func voteCount(in range: ClosedRange<Int>) -> Self {
        copy(voteCountMin: range.lowerBound, voteCountMax: range.upperBound)
    }

    ///
    /// Returns a copy of the filter restricted to the given runtime range.
    ///
    /// - Parameter range: The inclusive runtime range.
    ///
    /// - Returns: A new filter with the runtime range applied.
    ///
    func runtime(in range: ClosedRange<Duration>) -> Self {
        copy(runtimeMin: range.lowerBound, runtimeMax: range.upperBound)
    }

    ///
    /// Returns a copy of the filter with the adult content preference set.
    ///
    /// - Parameter include: Whether to include adult content.
    ///
    /// - Returns: A new filter with the adult content preference applied.
    ///
    func includeAdult(_ include: Bool) -> Self {
        copy(includeAdult: include)
    }

    ///
    /// Returns a copy of the filter restricted to the given watch providers.
    ///
    /// - Parameters:
    ///   - providers: A list of watch provider identifiers.
    ///   - region: An ISO-3166-1 watch region code.
    ///
    /// - Returns: A new filter with the watch providers applied. An empty
    ///   `providers` array is ignored and the filter is returned unchanged.
    ///
    func watchProviders(
        _ providers: [WatchProvider.ID],
        region: String? = nil
    ) -> Self {
        guard !providers.isEmpty else {
            return self
        }
        return copy(watchProviders: providers, watchRegion: region ?? watchRegion)
    }

}

extension DiscoverTVSeriesFilter {

    private func copy(
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil,
        withoutGenres: [Genre.ID]? = nil,
        firstAirDateYear: Int? = nil,
        voteAverageMin: Double? = nil,
        voteAverageMax: Double? = nil,
        voteCountMin: Int? = nil,
        voteCountMax: Int? = nil,
        networks: [Network.ID]? = nil,
        companies: [Company.ID]? = nil,
        keywords: [Keyword.ID]? = nil,
        withoutKeywords: [Keyword.ID]? = nil,
        runtimeMin: Duration? = nil,
        runtimeMax: Duration? = nil,
        includeAdult: Bool? = nil,
        watchProviders: [WatchProvider.ID]? = nil,
        watchRegion: String? = nil,
        genresJoin: DiscoverFilterJoin? = nil,
        keywordsJoin: DiscoverFilterJoin? = nil
    ) -> Self {
        DiscoverTVSeriesFilter(
            originalLanguage: originalLanguage ?? self.originalLanguage,
            genres: genres ?? self.genres,
            withoutGenres: withoutGenres ?? self.withoutGenres,
            firstAirDateYear: firstAirDateYear ?? self.firstAirDateYear,
            firstAirDateMin: firstAirDateMin,
            firstAirDateMax: firstAirDateMax,
            airDateMin: airDateMin,
            airDateMax: airDateMax,
            voteAverageMin: voteAverageMin ?? self.voteAverageMin,
            voteAverageMax: voteAverageMax ?? self.voteAverageMax,
            voteCountMin: voteCountMin ?? self.voteCountMin,
            voteCountMax: voteCountMax ?? self.voteCountMax,
            networks: networks ?? self.networks,
            companies: companies ?? self.companies,
            keywords: keywords ?? self.keywords,
            withoutKeywords: withoutKeywords ?? self.withoutKeywords,
            runtimeMin: runtimeMin ?? self.runtimeMin,
            runtimeMax: runtimeMax ?? self.runtimeMax,
            includeAdult: includeAdult ?? self.includeAdult,
            watchProviders: watchProviders ?? self.watchProviders,
            watchRegion: watchRegion ?? self.watchRegion,
            withOriginCountry: withOriginCountry,
            withStatus: withStatus,
            withType: withType,
            withoutCompanies: withoutCompanies,
            watchMonetizationTypes: watchMonetizationTypes,
            screenedTheatrically: screenedTheatrically,
            withPeople: withPeople,
            withoutWatchProviders: withoutWatchProviders,
            includeNullFirstAirDates: includeNullFirstAirDates,
            genresJoin: genresJoin ?? self.genresJoin,
            keywordsJoin: keywordsJoin ?? self.keywordsJoin
        )
    }

}
