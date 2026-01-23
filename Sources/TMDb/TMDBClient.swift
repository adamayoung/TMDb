//
//  TMDBClient.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    /// TMDb people.
    ///
    public let people: any PersonService

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
    /// Creates a TMDb client using `URLSession` as the `HTTPClient`.
    ///
    /// - Parameters:
    ///   - apiKey: The TMDb API key to use.
    ///   - configuration: The configuration for the client. Defaults to ``TMDbConfiguration/system``.
    ///
    public convenience init(apiKey: String, configuration: TMDbConfiguration = .system) {
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
        let apiClient = TMDbFactory.apiClient(apiKey: apiKey, httpClient: httpClient)
        let authAPIClient = TMDbFactory.authAPIClient(apiKey: apiKey, httpClient: httpClient)
        let authenticateURLBuilder = TMDbFactory.authenticateURLBuilder()

        self.init(
            configuration: configuration,
            accountService: TMDbAccountService(apiClient: apiClient),
            authenticationService: TMDbAuthenticationService(
                apiClient: authAPIClient,
                authenticateURLBuilder: authenticateURLBuilder
            ),
            certificationService: TMDbCertificationService(apiClient: apiClient),
            collectionService: TMDbCollectionService(
                apiClient: apiClient, configuration: configuration),
            companyService: TMDbCompanyService(apiClient: apiClient),
            configurationService: TMDbConfigurationService(apiClient: apiClient),
            discoverService: TMDbDiscoverService(
                apiClient: apiClient, configuration: configuration),
            findService: TMDbFindService(apiClient: apiClient, configuration: configuration),
            genreService: TMDbGenreService(apiClient: apiClient, configuration: configuration),
            keywordService: TMDbKeywordService(apiClient: apiClient),
            listService: TMDbListService(apiClient: apiClient),
            movieService: TMDbMovieService(apiClient: apiClient, configuration: configuration),
            personService: TMDbPersonService(apiClient: apiClient, configuration: configuration),
            searchService: TMDbSearchService(apiClient: apiClient, configuration: configuration),
            trendingService: TMDbTrendingService(
                apiClient: apiClient, configuration: configuration),
            tvEpisodeService: TMDbTVEpisodeService(
                apiClient: apiClient, configuration: configuration),
            tvSeasonService: TMDbTVSeasonService(
                apiClient: apiClient, configuration: configuration),
            tvSeriesService: TMDbTVSeriesService(
                apiClient: apiClient, configuration: configuration),
            watchProviderService: TMDbWatchProviderService(
                apiClient: apiClient, configuration: configuration)
        )
    }

    init(
        configuration: TMDbConfiguration = .system,
        accountService: some AccountService,
        authenticationService: some AuthenticationService,
        certificationService: some CertificationService,
        collectionService: some CollectionService,
        companyService: some CompanyService,
        configurationService: some ConfigurationService,
        discoverService: some DiscoverService,
        findService: some FindService,
        genreService: some GenreService,
        keywordService: some KeywordService,
        listService: some ListService,
        movieService: some MovieService,
        personService: some PersonService,
        searchService: some SearchService,
        trendingService: some TrendingService,
        tvEpisodeService: some TVEpisodeService,
        tvSeasonService: some TVSeasonService,
        tvSeriesService: some TVSeriesService,
        watchProviderService: some WatchProviderService
    ) {
        self.configuration = configuration
        self.account = accountService
        self.authentication = authenticationService
        self.certifications = certificationService
        self.collections = collectionService
        self.companies = companyService
        self.configurations = configurationService
        self.discover = discoverService
        self.find = findService
        self.genres = genreService
        self.keywords = keywordService
        self.lists = listService
        self.movies = movieService
        self.people = personService
        self.search = searchService
        self.trending = trendingService
        self.tvEpisodes = tvEpisodeService
        self.tvSeasons = tvSeasonService
        self.tvSeries = tvSeriesService
        self.watchProviders = watchProviderService
    }

}
