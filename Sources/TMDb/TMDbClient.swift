//
//  TMDbClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The main entry point for interacting with The Movie Database (TMDb)
/// API.
///
/// Use `TMDbClient` to access all TMDb services including movies, TV
/// series, people, search, discover, and more.
///
/// ```swift
/// let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")
///
/// let movie = try await tmdbClient.movies.details(forMovie: 550)
/// print(movie.title) // "Fight Club"
/// ```
///
/// - SeeAlso: <doc:/CreatingTMDbClient>
///
public final class TMDbClient: Sendable {

    ///
    /// The configuration for this client.
    ///
    public let configuration: TMDbConfiguration

    ///
    /// Provides access to user account features including favorites,
    /// watchlists, rated items, and account details.
    ///
    public let account: any AccountService

    ///
    /// Provides access to authentication features including session
    /// management, guest sessions, and request tokens.
    ///
    public let authentication: any AuthenticationService

    ///
    /// Provides access to content certifications (e.g. G, PG, R) for
    /// movies and TV series.
    ///
    public let certifications: any CertificationService

    ///
    /// Provides access to movie collection details, images, and
    /// translations.
    ///
    public let collections: any CollectionService

    ///
    /// Provides access to production company details, alternative names,
    /// and logos.
    ///
    public let companies: any CompanyService

    ///
    /// Provides access to API configuration including image base URLs,
    /// countries, languages, jobs, and timezones.
    ///
    public let configurations: any ConfigurationService

    ///
    /// Provides access to credit details including person and media
    /// information.
    ///
    public let credits: any CreditService

    ///
    /// Provides access to movie and TV series discovery with advanced
    /// filtering and sorting options.
    ///
    public let discover: any DiscoverService

    ///
    /// Provides access to finding movies, TV series, and people by
    /// external IDs (e.g. IMDb, TVDB).
    ///
    public let find: any FindService

    ///
    /// Provides access to genre lists for movies and TV series.
    ///
    public let genres: any GenreService

    ///
    /// Provides access to guest session rated movies, TV series, and
    /// episodes.
    ///
    public let guestSessions: any GuestSessionService

    ///
    /// Provides access to keyword details and discovering movies by
    /// keyword.
    ///
    public let keywords: any KeywordService

    ///
    /// Provides access to custom list management including creating,
    /// updating, and deleting lists.
    ///
    public let lists: any ListService

    ///
    /// Provides access to movie details, credits, images, videos,
    /// reviews, recommendations, similar movies, and more.
    ///
    public let movies: any MovieService

    ///
    /// Provides access to TV network details, alternative names, and
    /// logos.
    ///
    public let networks: any NetworkService

    ///
    /// Provides access to person details, combined credits, movie and
    /// TV credits, images, and external links.
    ///
    public let people: any PersonService

    ///
    /// Provides access to review details including author and media
    /// information.
    ///
    public let reviews: any ReviewService

    ///
    /// Provides access to searching for movies, TV series, people,
    /// collections, companies, and keywords.
    ///
    public let search: any SearchService

    ///
    /// Provides access to trending movies, TV series, people, and all
    /// media types.
    ///
    public let trending: any TrendingService

    ///
    /// Provides access to TV episode details, credits, images, videos,
    /// and translations.
    ///
    public let tvEpisodes: any TVEpisodeService

    ///
    /// Provides access to TV episode group details and episode
    /// organization.
    ///
    public let tvEpisodeGroups: any TVEpisodeGroupService

    ///
    /// Provides access to TV season details, aggregate credits, images,
    /// videos, translations, and watch providers.
    ///
    public let tvSeasons: any TVSeasonService

    ///
    /// Provides access to TV series details, credits, images, videos,
    /// reviews, recommendations, similar series, and more.
    ///
    public let tvSeries: any TVSeriesService

    ///
    /// Provides access to streaming and watch provider availability by
    /// region.
    ///
    public let watchProviders: any WatchProviderService

    ///
    /// Provides access to tracking changes made to movies, TV series,
    /// people, seasons, and episodes.
    ///
    public let changes: any ChangesService

    ///
    /// Creates a TMDb client using `URLSession` as the `HTTPClient`.
    ///
    /// - Parameters:
    ///   - apiKey: The TMDb API key to use.
    ///   - configuration: The configuration for the client. Defaults to ``TMDbConfiguration/system``.
    ///
    public convenience init(
        apiKey: String,
        configuration: TMDbConfiguration = .system
    ) {
        self.init(
            apiKey: apiKey,
            httpClient: TMDbFactory.defaultHTTPClientAdapter(),
            configuration: configuration
        )
    }

    ///
    /// Creates a TMDb client.
    ///
    /// - Parameters:
    ///   - apiKey: The TMDb API key to use.
    ///   - httpClient: A custom HTTP client adapter for making HTTP requests.
    ///   - configuration: The configuration for the client. Defaults to ``TMDbConfiguration/system``.
    ///
    public convenience init(
        apiKey: String,
        httpClient: some HTTPClient,
        configuration: TMDbConfiguration = .system
    ) {
        let dependencies = TMDbFactory.makeServiceDependencies(
            apiKey: apiKey,
            httpClient: httpClient,
            configuration: configuration
        )

        self.init(dependencies: dependencies, configuration: configuration)
    }

    private init(
        dependencies: TMDbServiceDependencies,
        configuration: TMDbConfiguration
    ) {
        let apiClient = dependencies.apiClient
        let authAPIClient = dependencies.authAPIClient
        let authenticateURLBuilder = dependencies.authenticateURLBuilder

        self.configuration = configuration
        self.account = TMDbAccountService(apiClient: apiClient)
        self.authentication = TMDbAuthenticationService(
            apiClient: authAPIClient,
            authenticateURLBuilder: authenticateURLBuilder
        )
        self.certifications = TMDbCertificationService(apiClient: apiClient)
        self.collections = TMDbCollectionService(apiClient: apiClient, configuration: configuration)
        self.companies = TMDbCompanyService(apiClient: apiClient)
        self.configurations = TMDbConfigurationService(apiClient: apiClient)
        self.credits = TMDbCreditService(apiClient: apiClient)
        self.discover = TMDbDiscoverService(apiClient: apiClient, configuration: configuration)
        self.find = TMDbFindService(apiClient: apiClient, configuration: configuration)
        self.genres = TMDbGenreService(apiClient: apiClient, configuration: configuration)
        self.guestSessions = TMDbGuestSessionService(apiClient: apiClient)
        self.keywords = TMDbKeywordService(apiClient: apiClient)
        self.lists = TMDbListService(apiClient: apiClient)
        self.movies = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        self.networks = TMDbNetworkService(apiClient: apiClient)
        self.people = TMDbPersonService(apiClient: apiClient, configuration: configuration)
        self.reviews = TMDbReviewService(apiClient: apiClient)
        self.search = TMDbSearchService(apiClient: apiClient, configuration: configuration)
        self.trending = TMDbTrendingService(apiClient: apiClient, configuration: configuration)
        self.tvEpisodes = TMDbTVEpisodeService(apiClient: apiClient, configuration: configuration)
        self.tvEpisodeGroups = TMDbTVEpisodeGroupService(apiClient: apiClient)
        self.tvSeasons = TMDbTVSeasonService(apiClient: apiClient, configuration: configuration)
        self.tvSeries = TMDbTVSeriesService(apiClient: apiClient, configuration: configuration)
        self.watchProviders = TMDbWatchProviderService(
            apiClient: apiClient,
            configuration: configuration
        )
        self.changes = TMDbChangesService(apiClient: apiClient)
    }

}
