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
    /// TMDb genres.
    ///
    public let genres: any GenreService

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
    /// - Parameter apiKey: The TMDb API key to use.
    ///
    public convenience init(apiKey: String) {
        self.init(
            apiKey: apiKey,
            httpClient: TMDbFactory.defaultHTTPClientAdapter()
        )
    }

    ///
    /// Creates a TMDb client.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///    - httpClient: A custom HTTP client adapter for making HTTP requests.
    ///
    public convenience init(apiKey: String, httpClient: some HTTPClient) {
        let apiClient = TMDbFactory.apiClient(apiKey: apiKey, httpClient: httpClient)
        let authAPIClient = TMDbFactory.authAPIClient(apiKey: apiKey, httpClient: httpClient)
        let authenticateURLBuilder = TMDbFactory.authenticateURLBuilder()

        self.init(
            accountService: TMDbAccountService(apiClient: apiClient),
            authenticationService: TMDbAuthenticationService(
                apiClient: authAPIClient,
                authenticateURLBuilder: authenticateURLBuilder
            ),
            certificationService: TMDbCertificationService(apiClient: apiClient),
            companyService: TMDbCompanyService(apiClient: apiClient),
            configurationService: TMDbConfigurationService(apiClient: apiClient),
            discoverService: TMDbDiscoverService(apiClient: apiClient),
            genreService: TMDbGenreService(apiClient: apiClient),
            listService: TMDbListService(apiClient: apiClient),
            movieService: TMDbMovieService(apiClient: apiClient),
            personService: TMDbPersonService(apiClient: apiClient),
            searchService: TMDbSearchService(apiClient: apiClient),
            trendingService: TMDbTrendingService(apiClient: apiClient),
            tvEpisodeService: TMDbTVEpisodeService(apiClient: apiClient),
            tvSeaonService: TMDbTVSeasonService(apiClient: apiClient),
            tvSeriesService: TMDbTVSeriesService(apiClient: apiClient),
            watchProviderService: TMDbWatchProviderService(apiClient: apiClient)
        )
    }

    init(
        accountService: some AccountService,
        authenticationService: some AuthenticationService,
        certificationService: some CertificationService,
        companyService: some CompanyService,
        configurationService: some ConfigurationService,
        discoverService: some DiscoverService,
        genreService: some GenreService,
        listService: some ListService,
        movieService: some MovieService,
        personService: some PersonService,
        searchService: some SearchService,
        trendingService: some TrendingService,
        tvEpisodeService: some TVEpisodeService,
        tvSeaonService: some TVSeasonService,
        tvSeriesService: some TVSeriesService,
        watchProviderService: some WatchProviderService
    ) {
        self.account = accountService
        self.authentication = authenticationService
        self.certifications = certificationService
        self.companies = companyService
        self.configurations = configurationService
        self.discover = discoverService
        self.genres = genreService
        self.lists = listService
        self.movies = movieService
        self.people = personService
        self.search = searchService
        self.trending = trendingService
        self.tvEpisodes = tvEpisodeService
        self.tvSeasons = tvSeaonService
        self.tvSeries = tvSeriesService
        self.watchProviders = watchProviderService
    }

}
