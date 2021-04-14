import Combine
import Foundation

public protocol SearchAPI {

    /// Publishes search results for movies, TV shows and people based on a query.
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with movies, TV shows and people matching the query.
    func searchPublisher(withQuery query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError>

    /// Publishes search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with movies matching the query.
    func searchMoviesPublisher(withQuery query: String, year: Int?,
                               page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - firstAirDateYear: The year of first air date to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with TV shows matching the query.
    func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with people matching the query.
    func searchPeoplePublisher(withQuery query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}

public extension SearchAPI {

    func searchPublisher(withQuery query: String, page: Int? = nil) -> AnyPublisher<MediaPageableList, TMDbError> {
        searchPublisher(withQuery: query, page: page)
    }

    func searchMoviesPublisher(withQuery query: String, year: Int?,
                               page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        searchMoviesPublisher(withQuery: query, year: year, page: page)
    }

    func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int?,
                                page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        searchTVShowsPublisher(withQuery: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    func searchPeoplePublisher(withQuery query: String,
                               page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        searchPeoplePublisher(withQuery: query, page: page)
    }

}
