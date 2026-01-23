//
//  TMDbMovieServiceConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceConfigurationTests {

    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
    }

    @Test("details uses configuration default language when no language provided")
    func detailsUsesConfigurationDefaultLanguage() async throws {
        let configuration = TMDbConfiguration(defaultLanguage: "es-ES")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = Movie.thorLoveAndThunder
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: expectedResult.id, language: "es-ES")

        _ = try await service.details(forMovie: expectedResult.id)

        #expect(apiClient.lastRequest as? MovieRequest == expectedRequest)
    }

    @Test("details explicit language overrides configuration default")
    func detailsExplicitLanguageOverridesDefault() async throws {
        let configuration = TMDbConfiguration(defaultLanguage: "es-ES")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = Movie.thorLoveAndThunder
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: expectedResult.id, language: "fr-FR")

        _ = try await service.details(forMovie: expectedResult.id, language: "fr-FR")

        #expect(apiClient.lastRequest as? MovieRequest == expectedRequest)
    }

    @Test("credits uses configuration default language when no language provided")
    func creditsUsesConfigurationDefaultLanguage() async throws {
        let configuration = TMDbConfiguration(defaultLanguage: "de-DE")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = ShowCredits.mock()
        let movieID = 550
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: "de-DE")

        _ = try await service.credits(forMovie: movieID)

        #expect(apiClient.lastRequest as? MovieCreditsRequest == expectedRequest)
    }

    @Test("recommendations uses configuration default language when no language provided")
    func recommendationsUsesConfigurationDefaultLanguage() async throws {
        let configuration = TMDbConfiguration(defaultLanguage: "it-IT")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = MoviePageableList.mock()
        let movieID = 550
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil, language: "it-IT")

        _ = try await service.recommendations(forMovie: movieID)

        #expect(apiClient.lastRequest as? MovieRecommendationsRequest == expectedRequest)
    }

    @Test("popular uses configuration default language and country when not provided")
    func popularUsesConfigurationDefaults() async throws {
        let configuration = TMDbConfiguration(defaultLanguage: "pt-BR", defaultCountry: "BR")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil, country: "BR", language: "pt-BR")

        _ = try await service.popular()

        #expect(apiClient.lastRequest as? PopularMoviesRequest == expectedRequest)
    }

    @Test("nowPlaying uses configuration default country when not provided")
    func nowPlayingUsesConfigurationDefaultCountry() async throws {
        let configuration = TMDbConfiguration(defaultCountry: "GB")
        let service = TMDbMovieService(apiClient: apiClient, configuration: configuration)
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil, country: "GB", language: nil)

        _ = try await service.nowPlaying()

        #expect(apiClient.lastRequest as? MoviesNowPlayingRequest == expectedRequest)
    }

}
