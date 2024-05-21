//
//  TMDBClient.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
public final class TMDbClient {

    ///
    /// TMDb account.
    ///
    public let account: any AccountService

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
    /// Creates a TMDb client.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
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
    public init(apiKey: String, httpClient: some HTTPClient) {
        let apiClient = TMDbFactory.apiClient(apiKey: apiKey, httpClient: httpClient)

        self.account = TMDbAccountService(apiClient: apiClient)

        self.certifications = TMDbCertificationService(apiClient: apiClient)
        self.companies = TMDbCompanyService(apiClient: apiClient)
        self.configurations = TMDbConfigurationService(apiClient: apiClient)
        self.discover = TMDbDiscoverService(apiClient: apiClient)
        self.genres = TMDbGenreService(apiClient: apiClient)
        self.movies = TMDbMovieService(apiClient: apiClient)
        self.people = TMDbPersonService(apiClient: apiClient)
        self.search = TMDbSearchService(apiClient: apiClient)
        self.trending = TMDbTrendingService(apiClient: apiClient)
        self.tvEpisodes = TMDbTVEpisodeService(apiClient: apiClient)
        self.tvSeasons = TMDbTVSeasonService(apiClient: apiClient)
        self.tvSeries = TMDbTVSeriesService(apiClient: apiClient)
    }

}
