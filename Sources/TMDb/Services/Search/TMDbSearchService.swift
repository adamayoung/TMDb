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

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbSearchService {

    func searchAll(query: String, page: Int?) async throws -> MediaPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchAll(query: query, page: page, completion: continuation.resume(with:))
        }
    }

    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchMovies(query: query, year: year, page: page, completion: continuation.resume(with:))
        }
    }

    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page,
                               completion: continuation.resume(with:))
        }
    }

    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchPeople(query: query, page: page, completion: continuation.resume(with:))
        }
    }

}
