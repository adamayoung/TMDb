@testable import TMDb
import XCTest

final class MockSearchService: SearchService {

    var media: MediaPageableList?
    private(set) var lastSearchAllQuery: String?
    private(set) var lastSearchAllPage: Int?
    var movies: MoviePageableList?
    private(set) var lastSearchMoviesQuery: String?
    private(set) var lastSearchMoviesYear: Int?
    private(set) var lastSearchMoviesPage: Int?
    var tvShows: TVShowPageableList?
    private(set) var lastSearchTVShowsQuery: String?
    private(set) var lastSearchTVShowsFirstAirDateYear: Int?
    private(set) var lastSearchTVShowsPage: Int?
    var people: PersonPageableList?
    private(set) var lastSearchPeopleQuery: String?
    private(set) var lastSearchPeoplePage: Int?

    func searchAll(query: String, page: Int?) async throws -> MediaPageableList {
        lastSearchAllQuery = query
        lastSearchAllPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let media = self.media else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: media)
        }
    }

    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList {
        lastSearchMoviesQuery = query
        lastSearchMoviesYear = year
        lastSearchMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movies)
        }
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?) async throws -> TVShowPageableList {
        lastSearchTVShowsQuery = query
        lastSearchTVShowsFirstAirDateYear = firstAirDateYear
        lastSearchTVShowsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShows = self.tvShows else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShows)
        }
    }

    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList {
        lastSearchPeopleQuery = query
        lastSearchPeoplePage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let people = self.people else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: people)
        }
    }

}
