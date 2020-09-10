import Combine
import Foundation

public final class TMDbMovieService: MovieService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchDetails(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    public func fetchCredits(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    public func fetchReviews(forMovie movieID: Movie.ID,
                             page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    public func fetchImages(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    public func fetchVideos(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    public func fetchRecommendations(forMovie movieID: Movie.ID,
                                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    public func fetchSimilar(toMovie movieID: Movie.ID,
                             page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    public func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

}
