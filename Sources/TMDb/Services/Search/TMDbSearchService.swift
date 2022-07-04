import Foundation

final class TMDbSearchService: SearchService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

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
