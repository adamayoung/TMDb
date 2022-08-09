import Foundation

final class TMDbGenreService: GenreService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func movieGenres() async throws -> [Genre] {
        let genreList: GenreList = try await apiClient.get(endpoint: GenresEndpoint.movie)
        return genreList.genres
    }

    func tvShowGenres() async throws -> [Genre] {
        let genreList: GenreList = try await apiClient.get(endpoint: GenresEndpoint.tvShow)
        return genreList.genres
    }

}
