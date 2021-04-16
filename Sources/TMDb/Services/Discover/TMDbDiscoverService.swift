import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbDiscoverService: DiscoverService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(sortBy: MovieSortBy?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortBy: sortBy, people: people, page: page),
                      completion: completion)
    }

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortBy: sortBy, page: page), completion: completion)
    }

}

#if canImport(Combine)
extension TMDbDiscoverService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(sortBy: MovieSortBy?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortBy: sortBy, people: people, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortBy: sortBy, page: page))
    }

}
#endif
