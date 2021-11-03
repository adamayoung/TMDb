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
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbSearchService {

    func searchAllPublisher(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
    }

    func searchMoviesPublisher(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
    }

    func searchTVShowsPublisher(query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear, page: page))
    }

    func searchPeoplePublisher(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
    }

}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbSearchService {

    func searchAll(query: String, page: Int?) async throws -> MediaPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
    }

    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear,
                                                                 page: page))
    }

    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
    }

}
#endif
