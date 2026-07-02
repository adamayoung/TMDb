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
            credential: .apiKey(apiKey),
            httpClient: httpClient,
            configuration: configuration
        )

        self.init(dependencies: dependencies, configuration: configuration)
    }

    ///
    /// Creates a TMDb client authenticated with a v4 access token, using
    /// `URLSession` as the `HTTPClient`.
    ///
    /// The token is sent as an `Authorization: Bearer` header rather than an
    /// `api_key` query item, keeping the credential out of request URLs (and
    /// therefore out of logs, proxies, and cache keys). Use the **API Read
    /// Access Token** from your TMDb account's API settings.
    ///
    /// - Parameters:
    ///   - bearerToken: The TMDb v4 access token to authenticate requests with.
    ///   - configuration: The configuration for the client. Defaults to ``TMDbConfiguration/system``.
    ///
    public convenience init(
        bearerToken: String,
        configuration: TMDbConfiguration = .system
    ) {
        self.init(
            bearerToken: bearerToken,
            httpClient: TMDbFactory.defaultHTTPClientAdapter(),
            configuration: configuration
        )
    }

    ///
    /// Creates a TMDb client authenticated with a v4 access token.
    ///
    /// The token is sent as an `Authorization: Bearer` header rather than an
    /// `api_key` query item, keeping the credential out of request URLs (and
    /// therefore out of logs, proxies, and cache keys). Use the **API Read
    /// Access Token** from your TMDb account's API settings.
    ///
    /// - Parameters:
    ///   - bearerToken: The TMDb v4 access token to authenticate requests with.
    ///   - httpClient: A custom HTTP client adapter for making HTTP requests.
    ///   - configuration: The configuration for the client. Defaults to ``TMDbConfiguration/system``.
    ///
    public convenience init(
        bearerToken: String,
        httpClient: some HTTPClient,
        configuration: TMDbConfiguration = .system
    ) {
        let dependencies = TMDbFactory.makeServiceDependencies(
            credential: .bearerToken(bearerToken),
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

#if canImport(NaturalLanguage)
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    public extension TMDbClient {

        ///
        /// Provides on-device, natural-language search across movies, TV series, and
        /// people.
        ///
        /// A prompt such as `"movies with Tom Hanks"` or `"cast of The Matrix"` is
        /// interpreted on device and executed against TMDb. Interpretation is
        /// deterministic (Apple's Natural Language framework); on supported devices
        /// with Apple Intelligence, Foundation Models additionally handles fuzzier,
        /// compositional prompts. On platforms without either, the prompt runs as a
        /// plain multi-search.
        ///
        /// - Note: Each access constructs a new service instance. When checking
        ///   ``NaturalLanguageSearchService/availability`` and then searching, store
        ///   it in a local first — `let search = client.naturalLanguageSearch` — rather
        ///   than accessing the property twice.
        ///
        var naturalLanguageSearch: any NaturalLanguageSearchService {
            let dataSource = LiveNaturalLanguageSearchDataSource(
                discover: discover,
                search: search,
                genres: genres,
                movies: movies,
                tvSeries: tvSeries,
                people: people,
                trending: trending
            )

            let deterministic = NaturalLanguageSearchPlanGenerator(
                classifier: RuleBasedIntentClassifier(),
                personExtractor: NLTaggerPersonNameExtractor(),
                languageDetector: NLLanguageRecognizerPromptDetector()
            )

            // Foundation Models is an optional fallback for the fuzzy tail, only on
            // capable OS versions. The NaturalLanguage planner is always the default.
            var fallback: (any SearchPlanGenerating)?
            #if canImport(FoundationModels)
                if #available(iOS 26, macOS 26, visionOS 26, watchOS 27, *) {
                    fallback = FoundationModelsSearchPlanGenerator()
                }
            #endif

            let planner = GatedSearchPlanGenerator(deterministic: deterministic, fallback: fallback)

            return TMDbNaturalLanguageSearchService(
                planner: planner,
                executor: SearchPlanExecutor(dataSource: dataSource),
                dataSource: dataSource
            )
        }

    }
#endif
