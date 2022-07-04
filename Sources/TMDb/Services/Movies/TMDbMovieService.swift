import Foundation

final class TMDbMovieService: MovieService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func details(forMovie id: Movie.ID) async throws -> Movie {
        try await apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        try await apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    func reviews(forMovie movieID: Movie.ID, page: Int?) async throws -> ReviewPageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        try await apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        try await apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    func recommendations(forMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    func similar(toMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    func nowPlaying(page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page))
    }

    func popular(page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

    func topRated(page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.topRated(page: page))
    }

    func upcoming(page: Int?) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page))
    }

}
