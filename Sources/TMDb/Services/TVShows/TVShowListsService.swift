import Foundation

/// A service to fetch various curated lists of TV shows.
public protocol TVShowListsService {

    /// Returns a list of recommended TV shows for a TV show.
    ///
    /// [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Recommended TV shows for the matching TV show as a pageable list.
    func recommendations(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList

    /// Returns a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Similar TV shows for the matching TV show as a pageable list.
    func similar(toTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList

    /// Returns a list current popular TV shows.
    ///
    /// [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular TV shows as a pageable list.
    func popular(page: Int?) async throws -> TVShowPageableList

}

public extension TVShowListsService {

    func recommendations(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        try await recommendations(forTVShow: tvShowID, page: page)
    }

    func similar(toTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        try await similar(toTVShow: tvShowID, page: page)
    }

    func popular(page: Int? = nil) async throws -> TVShowPageableList {
        try await popular(page: page)
    }

}
