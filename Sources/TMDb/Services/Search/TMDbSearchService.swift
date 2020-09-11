import Combine
import Foundation

public final class TMDbSearchService: SearchService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func searchAll(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
    }

    public func searchMovies(query: String, year: Int?,
                             page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
    }

    public func searchTVShows(query: String, firstAirDateYear: Int?,
                              page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear, page: page))
    }

    public func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
    }

}
