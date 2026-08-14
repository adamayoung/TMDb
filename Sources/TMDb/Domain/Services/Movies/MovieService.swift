//
//  MovieService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Provides an interface for obtaining movies from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol MovieService: Sendable {

    ///
    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movies: Details](https://developer.themoviedb.org/reference/movie-details)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movie.
    ///
    func details(forMovie movieID: Movie.ID, language: String?) async throws(TMDbError) -> Movie

    ///
    /// Returns the primary information about a movie with appended data.
    ///
    /// [TMDb API - Movies: Details](https://developer.themoviedb.org/reference/movie-details)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - appending: The additional data to append to the response.
    ///    - language: ISO 639-1 language code to display results in.
    ///     Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movie with appended data.
    ///
    func details(
        forMovie movieID: Movie.ID,
        appending: MovieAppendOption,
        language: String?
    ) async throws(TMDbError) -> MovieDetailsResponse

    ///
    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movies: Credits](https://developer.themoviedb.org/reference/movie-credits)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching movie.
    ///
    func credits(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    ///
    func reviews(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList

    ///
    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movies: Images](https://developer.themoviedb.org/reference/movie-images)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of images for the matching movie.
    ///
    func images(
        forMovie movieID: Movie.ID,
        filter: MovieImageFilter?
    ) async throws(TMDbError) -> ImageCollection

    ///
    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movies: Videos](https://developer.themoviedb.org/reference/movie-videos)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of videos for the matching movie.
    ///
    func videos(
        forMovie movieID: Movie.ID,
        filter: MovieVideoFilter?
    ) async throws(TMDbError) -> VideoCollection

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get recommendations for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    ///
    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get similar movies for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    ///
    func similar(
        toMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    func nowPlaying(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    func popular(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    func topRated(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    func upcoming(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList

    ///
    /// Returns watch providers for a movie in all available countries.
    ///
    /// [TMDb API - Movie: Watch providers](https://developer.themoviedb.org/reference/movie-watch-providers)
    ///
    /// Data provided by [JustWatch](https://www.justwatch.com).
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: Watch providers for the movie grouped by country.
    ///
    func watchProviders(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry]

    ///
    /// Returns a collection of media databases and social links for a movie.
    ///
    /// [TMDb API - Movie: External IDs](https://developer.themoviedb.org/reference/movie-external-ids)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the specified movie.
    ///
    func externalLinks(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> MovieExternalLinksCollection

    ///
    /// Returns the release dates and certifications for a movie by country.
    ///
    /// [TMDb API - Movies: Release Dates](https://developer.themoviedb.org/reference/movie-release-dates)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Release dates for the movie grouped by country.
    ///
    func releaseDates(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [MovieReleaseDatesByCountry]

    ///
    /// Returns the user's rating, favorite, and watchlist state for a movie.
    ///
    /// [TMDb API - Movies: Account States](https://developer.themoviedb.org/reference/movie-account-states)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The account states for the movie.
    ///
    func accountStates(
        forMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates

    ///
    /// Adds a rating for a movie.
    ///
    /// [TMDb API - Movies: Add Rating](https://developer.themoviedb.org/reference/movie-add-rating)
    ///
    /// - Precondition: `rating` must be between `0.5` and `10.0` in increments of `0.5`.
    ///
    /// - Parameters:
    ///    - rating: The rating value.
    ///    - movieID: The identifier of the movie.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addRating(
        _ rating: Double,
        toMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError)

    ///
    /// Deletes the user's rating for a movie.
    ///
    /// [TMDb API - Movies: Delete Rating](https://developer.themoviedb.org/reference/movie-delete-rating)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func deleteRating(forMovie movieID: Movie.ID, session: Session) async throws(TMDbError)

    ///
    /// Returns alternative titles for a movie.
    ///
    /// [TMDb API - Movies: Alternative Titles](https://developer.themoviedb.org/reference/movie-alternative-titles)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - country: ISO 3166-1 country code to filter results.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of alternative titles for the movie.
    ///
    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> AlternativeTitleCollection

    ///
    /// Returns translations for a movie.
    ///
    /// [TMDb API - Movies: Translations](https://developer.themoviedb.org/reference/movie-translations)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of translations for the movie.
    ///
    func translations(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> TranslationCollection<MovieTranslationData>

    ///
    /// Returns lists that contain the movie.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the movie as a pageable list.
    ///
    func lists(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection

    ///
    /// Returns the latest movie added to TMDb.
    ///
    /// [TMDb API - Movies: Latest](https://developer.themoviedb.org/reference/movie-latest-id)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The latest movie.
    ///
    func latest() async throws(TMDbError) -> Movie

    ///
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
    ///
    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection

    ///
    /// Returns keywords for a movie.
    ///
    /// [TMDb API - Movies: Keywords](https://developer.themoviedb.org/reference/movie-keywords)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of keywords for the movie.
    ///
    func keywords(forMovie movieID: Movie.ID) async throws(TMDbError) -> KeywordCollection

}

public extension MovieService {

    ///
    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movies: Details](https://developer.themoviedb.org/reference/movie-details)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movie.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func details(forMovie movieID: Movie.ID) async throws(TMDbError) -> Movie {
        try await details(forMovie: movieID, language: nil)
    }

    ///
    /// Returns the primary information about a movie with appended data.
    ///
    /// [TMDb API - Movies: Details](https://developer.themoviedb.org/reference/movie-details)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - appending: The additional data to append to the response.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movie with appended data.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func details(
        forMovie movieID: Movie.ID,
        appending: MovieAppendOption
    ) async throws(TMDbError) -> MovieDetailsResponse {
        try await details(
            forMovie: movieID,
            appending: appending,
            language: nil
        )
    }

    ///
    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movies: Credits](https://developer.themoviedb.org/reference/movie-credits)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching movie.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func credits(forMovie movieID: Movie.ID) async throws(TMDbError) -> ShowCredits {
        try await credits(forMovie: movieID, language: nil)
    }

    ///
    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movies: Images](https://developer.themoviedb.org/reference/movie-images)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of images for the matching movie.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func images(forMovie movieID: Movie.ID) async throws(TMDbError) -> ImageCollection {
        try await images(forMovie: movieID, filter: nil)
    }

    ///
    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movies: Videos](https://developer.themoviedb.org/reference/movie-videos)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of videos for the matching movie.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func videos(forMovie movieID: Movie.ID) async throws(TMDbError) -> VideoCollection {
        try await videos(forMovie: movieID, filter: nil)
    }
}
