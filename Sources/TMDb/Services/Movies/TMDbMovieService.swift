import Combine
import Foundation

final class TMDbMovieService: MovieService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    func fetchCredits(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    func fetchReviews(forMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    func fetchImages(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    func fetchVideos(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    func fetchRecommendations(forMovie movieID: MovieDTO.ID,
                              page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    func fetchSimilar(toMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

}
