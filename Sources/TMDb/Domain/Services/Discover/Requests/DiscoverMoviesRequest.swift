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

    mutating func apply(_ filter: DiscoverMovieFilter) {
        if let people = filter.people {
            self[.withPeople] = Self.idsQueryItemValue(for: people)
        }

        if let originalLanguage = filter.originalLanguage {
            self[.withOriginalLanguage] = originalLanguage
        }

        if let genres = filter.genres {
            self[.withGenres] = Self.idsQueryItemValue(for: genres)
        }

        if let withoutGenres = filter.withoutGenres {
            self[.withoutGenres] = Self.idsQueryItemValue(
                for: withoutGenres
            )
        }

        if let primaryReleaseYear = filter.primaryReleaseYear {
            let bounds = primaryReleaseYear.dateBounds()
            if let lte = bounds.lte {
                self[.primaryReleaseDateLessThan] = lte
            }
            if let gte = bounds.gte {
                self[.primaryReleaseDateGreaterThan] = gte
            }
        }

        applyVoteAndRuntimeFilters(from: filter)
        applyContentAndProviderFilters(from: filter)
    }

    mutating func applyVoteAndRuntimeFilters(
        from filter: DiscoverMovieFilter
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

        if let runtimeMin = filter.runtimeMin {
            self[.withRuntimeGreaterThan] = runtimeMin
        }

        if let runtimeMax = filter.runtimeMax {
            self[.withRuntimeLessThan] = runtimeMax
        }
    }

    mutating func applyContentAndProviderFilters(
        from filter: DiscoverMovieFilter
    ) {
        if let includeAdult = filter.includeAdult {
            self[.includeAdult] = includeAdult
        }

        if let includeVideo = filter.includeVideo {
            self[.includeVideo] = includeVideo
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

}
