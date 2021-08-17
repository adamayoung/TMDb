import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbDiscoverService: DiscoverService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortedBy: sortedBy, people: people, page: page),
                      completion: completion)
    }

    func fetchTVShows(sortedBy: TVShowSort?, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortedBy: sortedBy, page: page), completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbDiscoverService {

    func moviesPublisher(sortedBy: MovieSort?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortedBy: sortedBy, people: people, page: page))
    }

    func tvShowsPublisher(sortedBy: TVShowSort?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortedBy: sortedBy, page: page))
    }

}
#endif

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbDiscoverService {

    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchMovies(sortedBy: sortedBy, withPeople: people, page: page, completion: continuation.resume(with:))
        }
    }

    func tvShows(sortedBy: TVShowSort?, page: Int?) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTVShows(sortedBy: sortedBy, page: page, completion: continuation.resume(with:))
        }
    }

}
