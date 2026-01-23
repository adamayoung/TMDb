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
        let queryItems = APIRequestQueryItems(
            filter: filter,
            sortedBy: sortedBy,
            page: page,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) {
        self.init()

        if let filter {
            if let people = filter.people {
                self[.withPeople] = Self.peopleQueryItemValue(for: people)
            }

            if let originalLanguage = filter.originalLanguage {
                self[.withOriginalLanguage] = originalLanguage
            }

            if let genres = filter.genres {
                self[.withGenres] = genres.map(String.init).joined(separator: ",")
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
        }

        if let sortedBy {
            self[.sortBy] = sortedBy
        }

        if let page {
            self[.page] = page
        }

        if let language {
            self[.language] = language
        }
    }

    private static func peopleQueryItemValue(for people: [Person.ID]) -> String {
        people
            .map(\.description)
            .joined(separator: ",")
    }

}
