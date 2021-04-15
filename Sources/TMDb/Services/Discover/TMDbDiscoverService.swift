import Combine
import Foundation

final class TMDbDiscoverService: DiscoverService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(sortBy: MovieSortBy?, withPeople: [Person.ID]?,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortBy: sortBy, withPeople: withPeople, page: page))
    }

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortBy: sortBy, page: page))
    }

}
