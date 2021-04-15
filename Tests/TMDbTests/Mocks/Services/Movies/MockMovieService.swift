import Combine
@testable import TMDb
import XCTest

final class MockMovieService: MovieService {

    var movieDetails: Movie?
    private(set) var lastMovieDetailsID: Movie.ID?
    var credits: ShowCredits?
    private(set) var lastCreditsMovieID: Movie.ID?
    var reviews: ReviewPageableList?
    private(set) var lastReviewsMovieID: Movie.ID?
    private(set) var lastReviewsPage: Int?
    var images: ImageCollection?
    private(set) var lastImagesMovieID: Movie.ID?
    var videos: VideoCollection?
    private(set) var lastVideosMovieID: Movie.ID?
    var recommendations: MoviePageableList?
    private(set) var lastRecommendationsMovieID: Movie.ID?
    private(set) var lastRecommendationsPage: Int?
    var similar: MoviePageableList?
    private(set) var lastSimilarMovieID: Movie.ID?
    private(set) var lastSimilarPage: Int?
    var popular: MoviePageableList?
    private(set) var lastPopularPage: Int?

    func fetchDetails(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCredits(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(reviews)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchImages(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesMovieID = movieID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchVideos(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchRecommendations(forMovie movieID: Movie.ID,
                              page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(recommendations)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        guard let similar = similar else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(similar)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastPopularPage = page

        guard let popular = popular else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(popular)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
