import Combine
@testable import TMDb
import XCTest

final class MockMovieService: MovieService {

    var movieDetails: MovieDTO?
    private(set) var lastMovieDetailsID: MovieDTO.ID?
    var credits: ShowCreditsDTO?
    private(set) var lastCreditsMovieID: MovieDTO.ID?
    var reviews: ReviewPageableListDTO?
    private(set) var lastReviewsMovieID: MovieDTO.ID?
    private(set) var lastReviewsPage: Int?
    var images: ImageCollectionDTO?
    private(set) var lastImagesMovieID: MovieDTO.ID?
    var videos: VideoCollectionDTO?
    private(set) var lastVideosMovieID: MovieDTO.ID?
    var recommendations: MoviePageableListDTO?
    private(set) var lastRecommendationsMovieID: MovieDTO.ID?
    private(set) var lastRecommendationsPage: Int?
    var similar: MoviePageableListDTO?
    private(set) var lastSimilarMovieID: MovieDTO.ID?
    private(set) var lastSimilarPage: Int?
    var popular: MoviePageableListDTO?
    private(set) var lastPopularPage: Int?

    func fetchDetails(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError> {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCredits(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError> {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchReviews(forMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
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

    func fetchImages(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        lastImagesMovieID = movieID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchVideos(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchRecommendations(forMovie movieID: MovieDTO.ID,
                              page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
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

    func fetchSimilar(toMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
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

    func fetchPopular(page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
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
