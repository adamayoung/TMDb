//
//  DiscoverTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DiscoverTVSeriesRequest: DecodableAPIRequest<TVSeriesPageableList> {

    init(
        filter: DiscoverTVSeriesFilter? = nil,
        sortedBy: TVSeriesSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) {
        let path = "/discover/tv"
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

    mutating func apply(_ filter: DiscoverTVSeriesFilter) {
        self[ifPresent: .withOriginalLanguage] = filter.originalLanguage

        if let genres = filter.genres {
            self[.withGenres] = (filter.genresJoin ?? .and)
                .queryValue(for: genres)
        }

        if let withoutGenres = filter.withoutGenres {
            self[.withoutGenres] = Self.idsQueryItemValue(for: withoutGenres)
        }

        self[ifPresent: .firstAirDateYear] = filter.firstAirDateYear

        applyDateFilters(from: filter)
        applyVoteAndEntityFilters(from: filter)
        applyContentAndProviderFilters(from: filter)
    }

    mutating func applyDateFilters(from filter: DiscoverTVSeriesFilter) {
        if let firstAirDateMin = filter.firstAirDateMin {
            self[.firstAirDateGreaterThan] = Self.dateString(
                from: firstAirDateMin
            )
        }

        if let firstAirDateMax = filter.firstAirDateMax {
            self[.firstAirDateLessThan] = Self.dateString(
                from: firstAirDateMax
            )
        }

        if let airDateMin = filter.airDateMin {
            self[.airDateGreaterThan] = Self.dateString(from: airDateMin)
        }

        if let airDateMax = filter.airDateMax {
            self[.airDateLessThan] = Self.dateString(from: airDateMax)
        }
    }

    mutating func applyVoteAndEntityFilters(
        from filter: DiscoverTVSeriesFilter
    ) {
        self[ifPresent: .voteAverageGreaterThan] = filter.voteAverageMin
        self[ifPresent: .voteAverageLessThan] = filter.voteAverageMax
        self[ifPresent: .voteCountGreaterThan] = filter.voteCountMin
        self[ifPresent: .voteCountLessThan] = filter.voteCountMax

        if let networks = filter.networks {
            self[.withNetworks] = Self.idsQueryItemValue(for: networks)
        }

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
    }

    mutating func applyContentAndProviderFilters(
        from filter: DiscoverTVSeriesFilter
    ) {
        self[ifPresent: .withRuntimeGreaterThan] = filter.runtimeMin
        self[ifPresent: .withRuntimeLessThan] = filter.runtimeMax
        self[ifPresent: .includeAdult] = filter.includeAdult

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
        self[ifPresent: .includeNullFirstAirDates] = filter.includeNullFirstAirDates

        applyExtendedFilters(from: filter)
    }

    mutating func applyExtendedFilters(
        from filter: DiscoverTVSeriesFilter
    ) {
        self[ifPresent: .withOriginCountry] = filter.withOriginCountry

        if let withStatus = filter.withStatus {
            self[.withStatus] = withStatus
                .map { "\($0.rawValue)" }
                .joined(separator: "|")
        }

        if let withType = filter.withType {
            self[.withType] = withType
                .map { "\($0.rawValue)" }
                .joined(separator: "|")
        }

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

        self[ifPresent: .screenedTheatrically] = filter.screenedTheatrically

        if let withPeople = filter.withPeople {
            self[.withPeople] = Self.idsQueryItemValue(
                for: withPeople
            )
        }
    }

    static func dateString(from date: Date) -> String {
        DateFormatter.theMovieDatabase.string(from: date)
    }

}
