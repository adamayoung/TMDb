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

        if let sortedBy {
            queryItems[.sortBy] = sortedBy
        }

        if let page {
            queryItems[.page] = page
        }

        if let language {
            queryItems[.language] = language
        }

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    mutating func apply(_ filter: DiscoverTVSeriesFilter) {
        if let originalLanguage = filter.originalLanguage {
            self[.withOriginalLanguage] = originalLanguage
        }

        if let genres = filter.genres {
            self[.withGenres] = Self.idsQueryItemValue(for: genres)
        }

        if let withoutGenres = filter.withoutGenres {
            self[.withoutGenres] = Self.idsQueryItemValue(for: withoutGenres)
        }

        if let firstAirDateYear = filter.firstAirDateYear {
            self[.firstAirDateYear] = firstAirDateYear
        }

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
        if let voteAverageMin = filter.voteAverageMin {
            self[.voteAverageGreaterThan] = voteAverageMin
        }

        if let voteAverageMax = filter.voteAverageMax {
            self[.voteAverageLessThan] = voteAverageMax
        }

        if let voteCountMin = filter.voteCountMin {
            self[.voteCountGreaterThan] = voteCountMin
        }

        if let voteCountMax = filter.voteCountMax {
            self[.voteCountLessThan] = voteCountMax
        }

        if let networks = filter.networks {
            self[.withNetworks] = Self.idsQueryItemValue(for: networks)
        }

        if let companies = filter.companies {
            self[.withCompanies] = Self.idsQueryItemValue(for: companies)
        }

        if let keywords = filter.keywords {
            self[.withKeywords] = Self.idsQueryItemValue(for: keywords)
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
        if let runtimeMin = filter.runtimeMin {
            self[.withRuntimeGreaterThan] = runtimeMin
        }

        if let runtimeMax = filter.runtimeMax {
            self[.withRuntimeLessThan] = runtimeMax
        }

        if let includeAdult = filter.includeAdult {
            self[.includeAdult] = includeAdult
        }

        if let watchProviders = filter.watchProviders {
            self[.withWatchProviders] = Self.idsQueryItemValue(
                for: watchProviders
            )
        }

        if let watchRegion = filter.watchRegion {
            self[.watchRegion] = watchRegion
        }
    }

    static func dateString(from date: Date) -> String {
        DateFormatter.theMovieDatabase.string(from: date)
    }

}
