import Foundation

/// The Movie Database API.
///
/// [The Movie Database API Documentation](https://developers.themoviedb.org)
/// 
/// The TMDb API service is for those of you interested in using their movie, TV show or actor images and/or data in
/// your application. Their API is a system they provide for you and your team to programmatically fetch and use their
/// data and/or images.
public final class TMDbAPI {

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

    public convenience init(apiKey: String) {
        let apiClient = TMDbAPIClient(apiKey: apiKey, baseURL: .tmdbAPIBaseURL,
                                      urlSession: URLSession(configuration: .default),
                                      serialiser: Serialiser(decoder: .theMovieDatabase))

        self.init(
            certificationService: TMDbCertificationService(apiClient: apiClient),
            configurationService: TMDbConfigurationService(apiClient: apiClient),
            discoverService: TMDbDiscoverService(apiClient: apiClient),
            movieService: TMDbMovieService(apiClient: apiClient),
            personService: TMDbPersonService(apiClient: apiClient),
            searchService: TMDbSearchService(apiClient: apiClient),
            trendingService: TMDbTrendingService(apiClient: apiClient),
            tvShowService: TMDbTVShowService(apiClient: apiClient),
            tvShowSeasonService: TMDbTVShowSeasonService(apiClient: apiClient)
        )
    }

    init(certificationService: CertificationService, configurationService: ConfigurationService,
         discoverService: DiscoverService, movieService: MovieService, personService: PersonService,
         searchService: SearchService, trendingService: TrendingService, tvShowService: TVShowService,
         tvShowSeasonService: TVShowSeasonService) {
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

}
