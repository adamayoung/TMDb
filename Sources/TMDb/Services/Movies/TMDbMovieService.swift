import Combine
import Foundation

final class TMDbMovieService: MovieService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    func fetchCredits(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    func fetchImages(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    func fetchVideos(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    func fetchRecommendations(forMovie movieID: Movie.ID,
                              page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

}
