//
//  DiscoverMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DiscoverMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(
        filter: DiscoverMovieFilter? = nil,
        sortedBy: MovieSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/discover/movie"
        var queryItems = APIRequestQueryItems()

        if let filter {
            queryItems.apply(filter)
        }

        queryItems[ifPresent: .sortBy] = sortedBy
        queryItems[ifPresent: .page] = page
        queryItems[ifPresent: .language] = language

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    mutating func apply(_ filter: DiscoverMovieFilter) {
        if let people = filter.people {
            self[.withPeople] = Self.idsQueryItemValue(for: people)
        }

        self[ifPresent: .withOriginalLanguage] = filter.originalLanguage

        if let genres = filter.genres {
            self[.withGenres] = (filter.genresJoin ?? .and)
                .queryValue(for: genres)
        }

        if let withoutGenres = filter.withoutGenres {
            self[.withoutGenres] = Self.idsQueryItemValue(
                for: withoutGenres
            )
        }

        if let primaryReleaseYear = filter.primaryReleaseYear {
            let bounds = primaryReleaseYear.dateBounds()
            self[ifPresent: .primaryReleaseDateLessThan] = bounds.lte
            self[ifPresent: .primaryReleaseDateGreaterThan] = bounds.gte
        }

        if let releaseDateMin = filter.releaseDateMin {
            self[.releaseDateGreaterThan] = Self.dateString(from: releaseDateMin)
        }

        if let releaseDateMax = filter.releaseDateMax {
            self[.releaseDateLessThan] = Self.dateString(from: releaseDateMax)
        }

        applyVoteAndRuntimeFilters(from: filter)
        applyContentAndProviderFilters(from: filter)
    }

    mutating func applyVoteAndRuntimeFilters(
        from filter: DiscoverMovieFilter
    ) {
        self[ifPresent: .voteAverageGreaterThan] = filter.voteAverageMin
        self[ifPresent: .voteAverageLessThan] = filter.voteAverageMax
        self[ifPresent: .voteCountGreaterThan] = filter.voteCountMin
        self[ifPresent: .voteCountLessThan] = filter.voteCountMax

        if let companies = filter.companies {
            self[.withCompanies] = Self.idsQueryItemValue(for: companies)
        }

        if let keywords = filter.keywords {
            self[.withKeywords] = (filter.keywordsJoin ?? .and)
                .queryValue(for: keywords)
        }

        if let withoutKeywords = filter.withoutKeywords {
            self[.withoutKeywords] = Self.idsQueryItemValue(
                for: withoutKeywords
            )
        }

        self[ifPresent: .withRuntimeGreaterThan] = filter.runtimeMin
            .map { RuntimeMinutes.minutes(from: $0) }
        self[ifPresent: .withRuntimeLessThan] = filter.runtimeMax
            .map { RuntimeMinutes.minutes(from: $0) }
    }

    mutating func applyContentAndProviderFilters(
        from filter: DiscoverMovieFilter
    ) {
        self[ifPresent: .includeAdult] = filter.includeAdult
        self[ifPresent: .includeVideo] = filter.includeVideo

        if let watchProviders = filter.watchProviders {
            self[.withWatchProviders] = Self.idsQueryItemValue(
                for: watchProviders
            )
        }

        if let withoutWatchProviders = filter.withoutWatchProviders {
            self[.withoutWatchProviders] = Self.idsQueryItemValue(
                for: withoutWatchProviders
            )
        }

        self[ifPresent: .watchRegion] = filter.watchRegion

        applyCertificationAndExtendedFilters(from: filter)
    }

    mutating func applyCertificationAndExtendedFilters(
        from filter: DiscoverMovieFilter
    ) {
        self[ifPresent: .certification] = filter.certification
        self[ifPresent: .certificationMin] = filter.certificationMin
        self[ifPresent: .certificationMax] = filter.certificationMax
        self[ifPresent: .certificationCountry] = filter.certificationCountry

        if let releaseTypes = filter.releaseTypes {
            self[.withReleaseType] = releaseTypes
                .map { "\($0.rawValue)" }
                .joined(separator: "|")
        }

        if let withCast = filter.withCast {
            self[.withCast] = Self.idsQueryItemValue(for: withCast)
        }

        if let withCrew = filter.withCrew {
            self[.withCrew] = Self.idsQueryItemValue(for: withCrew)
        }

        self[ifPresent: .withOriginCountry] = filter.withOriginCountry

        if let withoutCompanies = filter.withoutCompanies {
            self[.withoutCompanies] = Self.idsQueryItemValue(
                for: withoutCompanies
            )
        }

        if let types = filter.watchMonetizationTypes {
            self[.withWatchMonetizationTypes] = types
                .map(\.rawValue)
                .joined(separator: "|")
        }
    }

    static func dateString(from date: Date) -> String {
        DateFormatter.theMovieDatabase.string(from: date)
    }

}
