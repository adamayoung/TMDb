///
/// Provides an interface for discovering movies and TV series from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol DiscoverService: Sendable {

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    func tvSeries(
        sortedBy: TVSeriesSort?,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

}

public extension DiscoverService {

    func movies(
        filter: DiscoverMovieFilter? = nil,
        sortedBy: MovieSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        try await movies(filter: filter, sortedBy: sortedBy, page: page, language: language)
    }

    func tvSeries(
        sortedBy: TVSeriesSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await tvSeries(sortedBy: sortedBy, page: page, language: language)
    }

}
