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
    /// - Returns: A new filter with the genres applied.
    ///
    func withGenres(
        _ genres: [Genre.ID],
        joinedBy join: DiscoverFilterJoin = .and
    ) -> Self {
        copy(genres: genres, genresJoin: join)
    }

    ///
    /// Returns a copy of the filter excluding the given genres.
    ///
    /// - Parameter genres: A list of genre identifiers to exclude.
    ///
    /// - Returns: A new filter with the excluded genres applied.
    ///
    func withoutGenres(_ genres: [Genre.ID]) -> Self {
        copy(withoutGenres: genres)
    }

    ///
    /// Returns a copy of the filter restricted to the given keywords.
    ///
    /// - Parameters:
    ///   - keywords: A list of keyword identifiers to match.
    ///   - join: The logical operator used to combine the keywords. Defaults
    ///     to ``DiscoverFilterJoin/and``.
    ///
    /// - Returns: A new filter with the keywords applied.
    ///
    func withKeywords(
        _ keywords: [Keyword.ID],
        joinedBy join: DiscoverFilterJoin = .and
    ) -> Self {
        copy(keywords: keywords, keywordsJoin: join)
    }

    ///
    /// Returns a copy of the filter excluding the given keywords.
    ///
    /// - Parameter keywords: A list of keyword identifiers to exclude.
    ///
    /// - Returns: A new filter with the excluded keywords applied.
    ///
    func withoutKeywords(_ keywords: [Keyword.ID]) -> Self {
        copy(withoutKeywords: keywords)
    }

    ///
    /// Returns a copy of the filter restricted to the given networks.
    ///
    /// - Parameter networks: A list of network identifiers.
    ///
    /// - Returns: A new filter with the networks applied.
    ///
    func withNetworks(_ networks: [Network.ID]) -> Self {
        copy(networks: networks)
    }

    ///
    /// Returns a copy of the filter restricted to the given companies.
    ///
    /// - Parameter companies: A list of production company identifiers.
    ///
    /// - Returns: A new filter with the companies applied.
    ///
    func withCompanies(_ companies: [Company.ID]) -> Self {
        copy(companies: companies)
    }

    ///
    /// Returns a copy of the filter restricted to the given original language.
    ///
    /// - Parameter language: An ISO-639-1 language code.
    ///
    /// - Returns: A new filter with the original language applied.
    ///
    func originalLanguage(_ language: String) -> Self {
        copy(originalLanguage: language)
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
    /// - Parameter range: The inclusive runtime range, in minutes.
    ///
    /// - Returns: A new filter with the runtime range applied.
    ///
    func runtime(in range: ClosedRange<Int>) -> Self {
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
    /// - Returns: A new filter with the watch providers applied.
    ///
    func watchProviders(
        _ providers: [WatchProvider.ID],
        region: String? = nil
    ) -> Self {
        copy(watchProviders: providers, watchRegion: region ?? watchRegion)
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
        runtimeMin: Int? = nil,
        runtimeMax: Int? = nil,
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
            genresJoin: genresJoin ?? self.genresJoin,
            keywordsJoin: keywordsJoin ?? self.keywordsJoin
        )
    }

}
