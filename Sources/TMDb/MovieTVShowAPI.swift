import Foundation

/// The Movie Database API.
///
/// - Note: [The Movie Database API Documentation](https://developers.themoviedb.org)
public protocol MovieTVShowAPI {

    /// Sets the TMDb API Key to be used with requests to the TMDb API.
    ///
    /// - Note: [TMDb API - Getting Started: Authentication](https://developers.themoviedb.org/3/getting-started/authentication#api-key)
    ///
    /// - Parameters
    ///     - apiKey: The TMDb API Key.
    static func setAPIKey(_ apiKey: String)

    /// Certifications.
    var certifications: CertificationService { get }

    /// Configurations.
    var configurations: ConfigurationService { get }

    /// Discover.
    var discover: DiscoverService { get }

    /// Movies.
    var movies: MovieService { get }

    /// People.
    var people: PersonService { get }

    /// Search.
    var search: SearchService { get }

    /// Trending.
    var trending: TrendingService { get }

    /// TV Shows.
    var tvShows: TVShowService { get }

    /// TV Show Seasons.
    var tvShowSeasons: TVShowSeasonService { get }

}
