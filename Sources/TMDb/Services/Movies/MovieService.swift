import Combine
import Foundation

protocol MovieService {

    func fetchDetails(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError>

    func fetchCredits(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError>

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError>

    func fetchImages(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError>

    func fetchRecommendations(forMovie movieID: Movie.ID,
                              page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

}
