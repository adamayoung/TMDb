//
//  TMDBClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The TMDb client.
///
public final class TMDbClient: Sendable {

    ///
    /// The configuration for this client.
    ///
    public let configuration: TMDbConfiguration

    ///
    /// TMDb account.
    ///
    public let account: any AccountService

    ///
    /// TMDb authentication.
    ///
    public let authentication: any AuthenticationService

    ///
    /// TMDb certifications.
    ///
    public let certifications: any CertificationService

    ///
    /// TMDb collections.
    ///
    public let collections: any CollectionService

    ///
    /// TMDb companies.
    ///
    public let companies: any CompanyService

    ///
    /// TMDb configuration.
    ///
    public let configurations: any ConfigurationService

    ///
    /// TMDb credits.
    ///
    public let credits: any CreditService

    ///
    /// TMDb discover.
    ///
    public let discover: any DiscoverService

    ///
    /// TMDb find.
    ///
    public let find: any FindService

    ///
    /// TMDb genres.
    ///
    public let genres: any GenreService

    ///
    /// TMDb guest sessions.
    ///
    public let guestSessions: any GuestSessionService

    ///
    /// TMDb keywords.
    ///
    public let keywords: any KeywordService

    ///
    /// TMDb lists.
    ///
    public let lists: any ListService

    ///
    /// TMDb movies.
    ///
    public let movies: any MovieService

    ///
    /// TMDb TV networks.
    ///
    public let networks: any NetworkService

    ///
    /// TMDb people.
    ///
    public let people: any PersonService

    ///
    /// TMDb reviews.
    ///
    public let reviews: any ReviewService

    ///
    /// TMDb search.
    ///
    public let search: any SearchService

    ///
    /// TMDb trending.
    ///
    public let trending: any TrendingService

    ///
    /// TMDb TV episodes.
    ///
    public let tvEpisodes: any TVEpisodeService

    ///
    /// TMDb TV episode groups.
    ///
    public let tvEpisodeGroups: any TVEpisodeGroupService

    ///
    /// TMDb TV seasons.
    ///
    public let tvSeasons: any TVSeasonService

    ///
    /// TMDb TV series.
    ///
    public let tvSeries: any TVSeriesService

    ///
    /// TMDb watch providers.
    ///
    public let watchProviders: any WatchProviderService

    ///
    /// TMDb changes.
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
        let apiClient = TMDbFactory.apiClient(
            apiKey: apiKey, httpClient: httpClient
        )
        let authAPIClient = TMDbFactory.authAPIClient(
            apiKey: apiKey, httpClient: httpClient
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
