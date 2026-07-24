//
//  DiscoverMovieFilter+Fluent.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

public extension DiscoverMovieFilter {

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
    /// Returns a copy of the filter restricted to the given people.
    ///
    /// - Parameter people: A list of Person identifiers to match.
    ///
    /// - Returns: A new filter with the people applied. An empty `people`
    ///   array is ignored and the filter is returned unchanged.
    ///
    func withPeople(_ people: [Person.ID]) -> Self {
        guard !people.isEmpty else {
            return self
        }
        return copy(people: people)
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
    /// Returns a copy of the filter restricted to the given release year.
    ///
    /// - Parameter year: The primary release year filter.
    ///
    /// - Returns: A new filter with the release year applied.
    ///
    func primaryReleaseYear(_ year: PrimaryReleaseYearFilter) -> Self {
        copy(primaryReleaseYear: year)
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
    /// Returns a copy of the filter with the video content preference set.
    ///
    /// - Parameter include: Whether to include video content.
    ///
    /// - Returns: A new filter with the video content preference applied.
    ///
    func includeVideo(_ include: Bool) -> Self {
        copy(includeVideo: include)
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

extension DiscoverMovieFilter {

    private func copy(
        people: [Person.ID]? = nil,
        originalLanguage: String? = nil,
        genres: [Genre.ID]? = nil,
        withoutGenres: [Genre.ID]? = nil,
        primaryReleaseYear: PrimaryReleaseYearFilter? = nil,
        voteAverageMin: Double? = nil,
        voteAverageMax: Double? = nil,
        voteCountMin: Int? = nil,
        voteCountMax: Int? = nil,
        companies: [Company.ID]? = nil,
        keywords: [Keyword.ID]? = nil,
        withoutKeywords: [Keyword.ID]? = nil,
        runtimeMin: Duration? = nil,
        runtimeMax: Duration? = nil,
        includeAdult: Bool? = nil,
        includeVideo: Bool? = nil,
        watchProviders: [WatchProvider.ID]? = nil,
        watchRegion: String? = nil,
        genresJoin: DiscoverFilterJoin? = nil,
        keywordsJoin: DiscoverFilterJoin? = nil
    ) -> Self {
        DiscoverMovieFilter(
            people: people ?? self.people,
            originalLanguage: originalLanguage ?? self.originalLanguage,
            genres: genres ?? self.genres,
            withoutGenres: withoutGenres ?? self.withoutGenres,
            primaryReleaseYear: primaryReleaseYear ?? self.primaryReleaseYear,
            voteAverageMin: voteAverageMin ?? self.voteAverageMin,
            voteAverageMax: voteAverageMax ?? self.voteAverageMax,
            voteCountMin: voteCountMin ?? self.voteCountMin,
            voteCountMax: voteCountMax ?? self.voteCountMax,
            companies: companies ?? self.companies,
            keywords: keywords ?? self.keywords,
            withoutKeywords: withoutKeywords ?? self.withoutKeywords,
            runtimeMin: runtimeMin ?? self.runtimeMin,
            runtimeMax: runtimeMax ?? self.runtimeMax,
            includeAdult: includeAdult ?? self.includeAdult,
            includeVideo: includeVideo ?? self.includeVideo,
            watchProviders: watchProviders ?? self.watchProviders,
            watchRegion: watchRegion ?? self.watchRegion,
            certification: certification,
            certificationMin: certificationMin,
            certificationMax: certificationMax,
            certificationCountry: certificationCountry,
            releaseTypes: releaseTypes,
            withCast: withCast,
            withCrew: withCrew,
            withOriginCountry: withOriginCountry,
            withoutCompanies: withoutCompanies,
            watchMonetizationTypes: watchMonetizationTypes,
            releaseDateMin: releaseDateMin,
            releaseDateMax: releaseDateMax,
            withoutWatchProviders: withoutWatchProviders,
            genresJoin: genresJoin ?? self.genresJoin,
            keywordsJoin: keywordsJoin ?? self.keywordsJoin
        )
    }

}
