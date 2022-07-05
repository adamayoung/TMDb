@testable import TMDb
import XCTest

final class MockDiscoverService: DiscoverService {

    var movies: MoviePageableList?
    private(set) var lastMoviesSortedBy: MovieSort?
    private(set) var lastMoviesWithPeople: [Person.ID]?
    private(set) var lastMoviesPage: Int?

    var tvShows: TVShowPageableList?
    private(set) var lastTVShowsSortedBy: TVShowSort?
    private(set) var lastTVShowsPage: Int?

    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList {
        lastMoviesSortedBy = sortedBy
        lastMoviesWithPeople = people
        lastMoviesPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let movies = self.movies else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movies)
        }
    }

    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        lastTVShowsSortedBy = sortedBy
        lastTVShowsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShows = self.tvShows else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShows)
        }
    }

}
