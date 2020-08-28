import Combine
import Foundation

public protocol MovieService {

    func fetchDetails(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError>

    func fetchCredits(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError>

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableListResult, TMDbError>

    func fetchImages(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError>

    func fetchVideos(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError>

    func fetchRecommendations(forMovie movieID: Movie.ID,
                              page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

}

extension MovieService {

    public func fetchReviews(forMovie movieID: Movie.ID,
                             page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, TMDbError> {
        fetchReviews(forMovie: movieID, page: page)
    }

    public func fetchRecommendations(forMovie movieID: Movie.ID,
                                     page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
        fetchRecommendations(forMovie: movieID, page: page)
    }

    public func fetchSimilar(toMovie movieID: Movie.ID,
                             page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
        fetchSimilar(toMovie: movieID, page: page)
    }

    public func fetchPopular(page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
        fetchPopular(page: page)
    }

}
