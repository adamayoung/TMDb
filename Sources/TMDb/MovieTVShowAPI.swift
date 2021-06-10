import Foundation

/// The Movie Database API.
public protocol MovieTVShowAPI {

    /// Sets the API Key to be used with requests to the API.
    ///
    /// - Parameters
    ///     - apiKey: The API Key.
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
