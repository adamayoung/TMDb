@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

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

    func fetchDetails(forMovie id: Movie.ID, completion: @escaping (Result<Movie, TMDbError>) -> Void) {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movieDetails))
        }
    }

    func fetchCredits(forMovie movieID: Movie.ID, completion: @escaping (Result<ShowCredits, TMDbError>) -> Void) {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(credits))
        }
    }

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(reviews))
        }
    }

    func fetchImages(forMovie movieID: Movie.ID, completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        lastImagesMovieID = movieID

        guard let images = images else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(images))
        }
    }

    func fetchVideos(forMovie movieID: Movie.ID, completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(videos))
        }
    }

    func fetchRecommendations(forMovie movieID: Movie.ID, page: Int?,
                              completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(recommendations))
        }
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        guard let similar = similar else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(similar))
        }
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastPopularPage = page

        guard let popular = popular else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(popular))
        }
    }

}

#if canImport(Combine)
extension MockMovieService {

    func detailsPublisher(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func creditsPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func reviewsPublisher(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
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

    func imagesPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesMovieID = movieID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func videosPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func recommendationsPublisher(forMovie movieID: Movie.ID,
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

    func similarPublisher(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
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

    func popularPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
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
#endif
