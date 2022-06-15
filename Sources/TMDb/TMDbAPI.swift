import Foundation

/// The Movie Database API.
///
/// [The Movie Database API Documentation](https://developers.themoviedb.org)
/// 
/// The TMDb API service is for those of you interested in using their movie, TV show or actor images and/or data in your application. Their API is a system they
/// provide for you and your team to programmatically fetch and use their data and/or images.
public final class TMDbAPI {

    /// A shared instance of the TMDb API.
    public static let shared = TMDbAPI()

    /// Certifications.
    public let certifications: CertificationService
    /// Configurations.
    public let configurations: ConfigurationService
    /// Discover.
    public let discover: DiscoverService
    /// Movies.
    public let movies: MovieService
    /// People.
    public let people: PersonService
    /// Search.
    public let search: SearchService
    /// Trending.
    public let trending: TrendingService
    /// TV Shows.
    public let tvShows: TVShowService
    /// TV Show Seasons.
    public let tvShowSeasons: TVShowSeasonService

    init(
        certificationService: CertificationService = TMDbCertificationService(),
        configurationService: ConfigurationService = TMDbConfigurationService(),
        discoverService: DiscoverService = TMDbDiscoverService(),
        movieService: MovieService = TMDbMovieService(),
        personService: PersonService = TMDbPersonService(),
        searchService: SearchService = TMDbSearchService(),
        trendingService: TrendingService = TMDbTrendingService(),
        tvShowService: TVShowService = TMDbTVShowService(),
        tvShowSeasonService: TVShowSeasonService = TMDbTVShowSeasonService()
    ) {
        self.certifications = certificationService
        self.configurations = configurationService
        self.discover = discoverService
        self.movies = movieService
        self.people = personService
        self.search = searchService
        self.trending = trendingService
        self.tvShows = tvShowService
        self.tvShowSeasons = tvShowSeasonService
    }

    /// Sets the API Key to be used with requests to the API.
    ///
    /// - Parameters
    ///     - apiKey: The API Key.
    public static func setAPIKey(_ apiKey: String) {
        TMDbAPIClient.setAPIKey(apiKey)
    }

}
