//
//  SearchService.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

///
/// Provides an interface for searching content from TMDb..
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class SearchService {

    private let apiClient: APIClient

    ///
    /// Creates a search service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    public func searchAll(query: String, page: Int? = nil) async throws -> MediaPageableList {
        let mediaList: MediaPageableList
        do {
            mediaList = try await apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
        } catch {
            throw TMDbError(error: error)
        }

        return mediaList
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - year: The year to filter results for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    public func searchMovies(query: String, year: Int? = nil, page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
        } catch {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - firstAirDateYear: The year of first air date to filter results for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    public func searchTVSeries(query: String, firstAirDateYear: Int? = nil,
                               page: Int? = nil) async throws -> TVSeriesPageableList
    {
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: SearchEndpoint.tvSeries(query: query, firstAirDateYear: firstAirDateYear, page: page)
            )
        } catch {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    public func searchPeople(query: String, page: Int? = nil) async throws -> PersonPageableList {
        let peopleList: PersonPageableList
        do {
            peopleList = try await apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
        } catch {
            throw TMDbError(error: error)
        }

        return peopleList
    }

}
