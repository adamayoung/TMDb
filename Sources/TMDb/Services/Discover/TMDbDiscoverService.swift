import Combine
import Foundation

public final class TMDbDiscoverService: DiscoverService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchMovies(sortBy: MovieSortBy?, withPeople: [Person.ID]?,
                            page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.movies(sortBy: sortBy, withPeople: withPeople, page: page))
    }

    public func fetchTVShows(sortBy: TVShowSortBy? = nil,
                             page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortBy: sortBy, page: page))
    }

}
