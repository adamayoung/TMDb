//
//  MovieService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``MovieService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated movie endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension MovieService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all popular movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allPopular(
        country: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await popular(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all top rated movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allTopRated(
        country: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await topRated(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all currently playing movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allNowPlaying(
        country: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await nowPlaying(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all upcoming movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allUpcoming(
        country: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await upcoming(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all recommended movies for a movie across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie to get recommendations for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allRecommendations(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await recommendations(forMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all similar movies for a movie across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie to get similar movies for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allSimilar(
        toMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await similar(toMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all reviews for a movie across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``Review`` objects.
    ///
    func allReviews(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<Review> {
        PagedAsyncSequence { [self] page in
            try await reviews(forMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all lists containing a movie across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MediaListSummary`` objects.
    ///
    func allLists(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<MediaListSummary> {
        PagedAsyncSequence { [self] page in
            try await lists(forMovie: movieID, page: page, language: language)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all popular movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allPopularPages(
        country: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await popular(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all top rated movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allTopRatedPages(
        country: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await topRated(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all now playing movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allNowPlayingPages(
        country: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await nowPlaying(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all upcoming movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allUpcomingPages(
        country: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await upcoming(page: page, country: country, language: language)
        }
    }

    ///
    /// Returns an async sequence of all recommendation pages for a movie.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie to get recommendations for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allRecommendationsPages(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await recommendations(forMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all similar movie pages for a movie.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie to get similar movies for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allSimilarPages(
        toMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await similar(toMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all review pages for a movie.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``Review`` objects.
    ///
    func allReviewsPages(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<Review> {
        PagedPagesAsyncSequence { [self] page in
            try await reviews(forMovie: movieID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all list pages containing a movie.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MediaListSummary`` objects.
    ///
    func allListsPages(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MediaListSummary> {
        PagedPagesAsyncSequence { [self] page in
            try await lists(forMovie: movieID, page: page, language: language)
        }
    }

}
