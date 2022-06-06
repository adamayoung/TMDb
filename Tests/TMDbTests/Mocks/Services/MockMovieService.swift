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
    var nowPlaying: MoviePageableList?
    private(set) var lastNowPlayingPage: Int?
    var popular: MoviePageableList?
    private(set) var lastPopularPage: Int?
    var topRated: MoviePageableList?
    private(set) var lastTopRatedPage: Int?
    var upcoming: MoviePageableList?
    private(set) var lastUpcomingPage: Int?

    func details(forMovie id: Movie.ID) async throws -> Movie {
        lastMovieDetailsID = id

        return try await withCheckedThrowingContinuation { continuation in
            guard let movieDetails = self.movieDetails else {
                return
            }

            continuation.resume(returning: movieDetails)
        }
    }

    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        lastCreditsMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let credits = self.credits else {
                return
            }

            continuation.resume(returning: credits)
        }
    }

    func reviews(forMovie movieID: Movie.ID, page: Int?) async throws -> ReviewPageableList {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let reviews = self.reviews else {
                return
            }

            continuation.resume(returning: reviews)
        }
    }

    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        lastImagesMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        lastVideosMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                return
            }

            continuation.resume(returning: videos)
        }
    }

    func recommendations(forMovie movieID: Movie.ID,
                         page: Int?) async throws -> MoviePageableList {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let recommendations = self.recommendations else {
                return
            }

            continuation.resume(returning: recommendations)
        }
    }

    func similar(toMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let similar = self.similar else {
                return
            }

            continuation.resume(returning: similar)
        }
    }

    func nowPlaying(page: Int?) async throws -> MoviePageableList {
        lastNowPlayingPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let nowPlaying = self.nowPlaying else {
                return
            }

            continuation.resume(returning: nowPlaying)
        }
    }

    func popular(page: Int?) async throws -> MoviePageableList {
        lastPopularPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let popular = self.popular else {
                return
            }

            continuation.resume(returning: popular)
        }
    }

    func topRated(page: Int?) async throws -> MoviePageableList {
        lastTopRatedPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let topRated = self.topRated else {
                return
            }

            continuation.resume(returning: topRated)
        }
    }

    func upcoming(page: Int?) async throws -> MoviePageableList {
        lastUpcomingPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let upcoming = self.upcoming else {
                return
            }

            continuation.resume(returning: upcoming)
        }
    }

}
