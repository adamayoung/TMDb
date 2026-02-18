//
//  TMDBClient.swift
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

    // swiftlint:disable function_body_length
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
        let wrappedHTTPClient = TMDbFactory.httpClient(
            wrapping: httpClient,
            retryConfiguration: configuration.retry,
            cacheConfiguration: configuration.cache
        )
        let apiClient = TMDbFactory.apiClient(
            apiKey: apiKey, httpClient: wrappedHTTPClient
        )
        let authAPIClient = TMDbFactory.authAPIClient(
            apiKey: apiKey, httpClient: wrappedHTTPClient
        )
        let authenticateURLBuilder =
            TMDbFactory.authenticateURLBuilder()

        self.init(
            configuration: configuration,
            accountService: TMDbAccountService(
                apiClient: apiClient
            ),
            authenticationService: TMDbAuthenticationService(
                apiClient: authAPIClient,
                authenticateURLBuilder: authenticateURLBuilder
            ),
            certificationService: TMDbCertificationService(
                apiClient: apiClient
            ),
            collectionService: TMDbCollectionService(
                apiClient: apiClient,
                configuration: configuration
            ),
            companyService: TMDbCompanyService(
                apiClient: apiClient
            ),
            configurationService: TMDbConfigurationService(
                apiClient: apiClient
            ),
            creditService: TMDbCreditService(
                apiClient: apiClient
            ),
            discoverService: TMDbDiscoverService(
                apiClient: apiClient,
                configuration: configuration
            ),
            findService: TMDbFindService(
                apiClient: apiClient,
                configuration: configuration
            ),
            genreService: TMDbGenreService(
                apiClient: apiClient,
                configuration: configuration
            ),
            guestSessionService: TMDbGuestSessionService(
                apiClient: apiClient
            ),
            keywordService: TMDbKeywordService(
                apiClient: apiClient
            ),
            listService: TMDbListService(
                apiClient: apiClient
            ),
            movieService: TMDbMovieService(
                apiClient: apiClient,
                configuration: configuration
            ),
            networkService: TMDbNetworkService(
                apiClient: apiClient
            ),
            personService: TMDbPersonService(
                apiClient: apiClient,
                configuration: configuration
            ),
            reviewService: TMDbReviewService(
                apiClient: apiClient
            ),
            searchService: TMDbSearchService(
                apiClient: apiClient,
                configuration: configuration
            ),
            trendingService: TMDbTrendingService(
                apiClient: apiClient,
                configuration: configuration
            ),
            tvEpisodeService: TMDbTVEpisodeService(
                apiClient: apiClient,
                configuration: configuration
            ),
            tvEpisodeGroupService: TMDbTVEpisodeGroupService(
                apiClient: apiClient
            ),
            tvSeasonService: TMDbTVSeasonService(
                apiClient: apiClient,
                configuration: configuration
            ),
            tvSeriesService: TMDbTVSeriesService(
                apiClient: apiClient,
                configuration: configuration
            ),
            watchProviderService: TMDbWatchProviderService(
                apiClient: apiClient, configuration: configuration
            ),
            changesService: TMDbChangesService(apiClient: apiClient)
        )
    }

    // swiftlint:enable function_body_length

    init(
        configuration: TMDbConfiguration = .system,
        accountService: some AccountService,
        authenticationService: some AuthenticationService,
        certificationService: some CertificationService,
        collectionService: some CollectionService,
        companyService: some CompanyService,
        configurationService: some ConfigurationService,
        creditService: some CreditService,
        discoverService: some DiscoverService,
        findService: some FindService,
        genreService: some GenreService,
        guestSessionService: some GuestSessionService,
        keywordService: some KeywordService,
        listService: some ListService,
        movieService: some MovieService,
        networkService: some NetworkService,
        personService: some PersonService,
        reviewService: some ReviewService,
        searchService: some SearchService,
        trendingService: some TrendingService,
        tvEpisodeService: some TVEpisodeService,
        tvEpisodeGroupService: some TVEpisodeGroupService,
        tvSeasonService: some TVSeasonService,
        tvSeriesService: some TVSeriesService,
        watchProviderService: some WatchProviderService,
        changesService: some ChangesService
    ) {
        self.configuration = configuration
        self.account = accountService
        self.authentication = authenticationService
        self.certifications = certificationService
        self.collections = collectionService
        self.companies = companyService
        self.configurations = configurationService
        self.credits = creditService
        self.discover = discoverService
        self.find = findService
        self.genres = genreService
        self.guestSessions = guestSessionService
        self.keywords = keywordService
        self.lists = listService
        self.movies = movieService
        self.networks = networkService
        self.people = personService
        self.reviews = reviewService
        self.search = searchService
        self.trending = trendingService
        self.tvEpisodes = tvEpisodeService
        self.tvEpisodeGroups = tvEpisodeGroupService
        self.tvSeasons = tvSeasonService
        self.tvSeries = tvSeriesService
        self.watchProviders = watchProviderService
        self.changes = changesService
    }

}
