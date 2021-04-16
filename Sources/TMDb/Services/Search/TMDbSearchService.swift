import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbSearchService: SearchService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func searchAll(query: String, page: Int?, completion: @escaping (Result<MediaPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page), completion: completion)
    }

    func searchMovies(query: String, year: Int?, page: Int?,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page), completion: completion)
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?,
                       completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear, page: page),
                      completion: completion)
    }

    func searchPeople(query: String, page: Int?,
                      completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page), completion: completion)
    }

}

#if canImport(Combine)
extension TMDbSearchService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchAllPublisher(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchMoviesPublisher(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchTVShowsPublisher(query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear, page: page))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchPeoplePublisher(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
    }

}
#endif
