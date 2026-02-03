//
//  TMDbClientTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct TMDbClientTests {

    var apiKey: String!

    init() {
        self.apiKey = "test-api-key"
    }

    @Test("init with API key creates account service")
    func initWithAPIKeyCreatesAccountService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.account is TMDbAccountService)
    }

    @Test("init with API key creates authentication service")
    func initWithAPIKeyCreatesAuthenticationService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.authentication is TMDbAuthenticationService)
    }

    @Test("init with API key creates certification service")
    func initWithAPIKeyCreatesCertificationService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.certifications is TMDbCertificationService)
    }

    @Test("init with API key creates company service")
    func initWithAPIKeyCreatesCompanyService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.companies is TMDbCompanyService)
    }

    @Test("init with API key creates configuration service")
    func initWithAPIKeyCreatesConfigurationService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.configurations is TMDbConfigurationService)
    }

    @Test("init with API key creates discover service")
    func initWithAPIKeyCreatesDiscoverService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.discover is TMDbDiscoverService)
    }

    @Test("init with API key creates genre service")
    func initWithAPIKeyCreatesGenreService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.genres is TMDbGenreService)
    }

    @Test("init with API key creates movie service")
    func initWithAPIKeyCreatesMovieService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.movies is TMDbMovieService)
    }

    @Test("init with API key creates person service")
    func initWithAPIKeyCreatesPersonService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.people is TMDbPersonService)
    }

    @Test("init with API key creates search service")
    func initWithAPIKeyCreatesSearchService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.search is TMDbSearchService)
    }

    @Test("init with API key creates trending service")
    func initWithAPIKeyCreatesTrendingService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.trending is TMDbTrendingService)
    }

    @Test("init with API key creates TV episode service")
    func initWithAPIKeyCreatesTVEpisodeService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.tvEpisodes is TMDbTVEpisodeService)
    }

    @Test("init with API key creates TV season service")
    func initWithAPIKeyCreatesTVSeasonService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.tvSeasons is TMDbTVSeasonService)
    }

    @Test("init with API key creates TV series service")
    func initWithAPIKeyCreatesTVSeriesService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.tvSeries is TMDbTVSeriesService)
    }

    @Test("init with API key creates watch provider service")
    func initWithAPIKeyCreatesWatchProviderService() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.watchProviders is TMDbWatchProviderService)
    }

    @Test("init with API key has system configuration")
    func initWithAPIKeyHasSystemConfiguration() {
        let client = TMDbClient(apiKey: apiKey)

        #expect(client.configuration == .system)
    }

    @Test("init with configuration stores configuration")
    func initWithConfigurationStoresConfiguration() {
        let configuration = TMDbConfiguration(defaultLanguage: "es-ES", defaultCountry: "ES")
        let client = TMDbClient(apiKey: apiKey, configuration: configuration)

        #expect(client.configuration == configuration)
        #expect(client.configuration.defaultLanguage == "es-ES")
        #expect(client.configuration.defaultCountry == "ES")
    }

}
