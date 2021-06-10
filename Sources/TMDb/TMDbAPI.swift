import Foundation

/// The Movie Database API.
///
/// [The Movie Database API Documentation](https://developers.themoviedb.org)
/// 
/// The TMDb API service is for those of you interested in using their movie, TV show or actor images and/or data in your application. Their API is a system they
/// provide for you and your team to programmatically fetch and use their data and/or images.
public final class TMDbAPI: MovieTVShowAPI {

    /// A shared instance of the TMDb API.
    public static let shared: MovieTVShowAPI = TMDbAPI()

    public let certifications: CertificationService
    public let configurations: ConfigurationService
    public let discover: DiscoverService
    public let movies: MovieService
    public let people: PersonService
    public let search: SearchService
    public let trending: TrendingService
    public let tvShows: TVShowService
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

    public static func setAPIKey(_ apiKey: String) {
        TMDbAPIClient.setAPIKey(apiKey)
    }

}
