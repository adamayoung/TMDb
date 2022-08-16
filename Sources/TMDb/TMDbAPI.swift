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
    /// Companies.
    public let companies: CompanyService
    /// Configurations.
    public let configurations: ConfigurationService
    /// Discover.
    public let discover: DiscoverService
    /// Genres.
    public let genres: GenreService
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
    /// TV Show Episodes.
    public let tvShowEpisodes: TVShowEpisodeService
    /// Watch Providers.
    public let watchProviders: WatchProviderService

    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, urlSessionConfiguration: .default)
    }

    convenience init(apiKey: String, baseURL: URL = .tmdbAPIBaseURL, urlSessionConfiguration: URLSessionConfiguration) {
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        let serialiser = Serialiser(decoder: .theMovieDatabase)
        let apiClient = TMDbAPIClient(apiKey: apiKey, baseURL: baseURL, urlSession: urlSession, serialiser: serialiser)

        self.init(
            certificationService: TMDbCertificationService(apiClient: apiClient),
            companyService: TMDbCompanyService(apiClient: apiClient),
            configurationService: TMDbConfigurationService(apiClient: apiClient),
            discoverService: TMDbDiscoverService(apiClient: apiClient),
            genreService: TMDbGenreService(apiClient: apiClient),
            movieService: TMDbMovieService(apiClient: apiClient),
            personService: TMDbPersonService(apiClient: apiClient),
            searchService: TMDbSearchService(apiClient: apiClient),
            trendingService: TMDbTrendingService(apiClient: apiClient),
            tvShowService: TMDbTVShowService(apiClient: apiClient),
            tvShowSeasonService: TMDbTVShowSeasonService(apiClient: apiClient),
            tvShowEpisodeService: TMDbTVShowEpisodeService(apiClient: apiClient),
            watchProviderService: TMDbWatchProviderService(apiClient: apiClient)
        )
    }

    init(certificationService: CertificationService, companyService: CompanyService,
         configurationService: ConfigurationService, discoverService: DiscoverService, genreService: GenreService,
         movieService: MovieService, personService: PersonService, searchService: SearchService,
         trendingService: TrendingService, tvShowService: TVShowService, tvShowSeasonService: TVShowSeasonService,
         tvShowEpisodeService: TVShowEpisodeService, watchProviderService: WatchProviderService) {
        self.certifications = certificationService
        self.companies = companyService
        self.configurations = configurationService
        self.discover = discoverService
        self.genres = genreService
        self.movies = movieService
        self.people = personService
        self.search = searchService
        self.trending = trendingService
        self.tvShows = tvShowService
        self.tvShowSeasons = tvShowSeasonService
        self.tvShowEpisodes = tvShowEpisodeService
        self.watchProviders = watchProviderService
    }

}
