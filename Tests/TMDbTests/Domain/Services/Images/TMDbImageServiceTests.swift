//
//  TMDbImageServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .images))
struct TMDbImageServiceTests {

    private static func makeConfiguration() throws -> ImagesConfiguration {
        try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
    }

    private static func makeService(
        configuration: ImagesConfiguration
    ) -> (TMDbImageService, CountingConfigurationService) {
        let configurationService = CountingConfigurationService()
        configurationService.enqueue(.success(.mock(images: configuration)))

        return (TMDbImageService(configurationService: configurationService), configurationService)
    }

    @Test("imagesConfiguration returns the images configuration, fetching once")
    func imagesConfigurationReturnsImagesConfigurationFetchingOnce() async throws {
        let expectedResult = ImagesConfiguration.mock()
        let configurationService = CountingConfigurationService()
        configurationService.enqueue(.success(.mock(images: expectedResult)))
        let service = TMDbImageService(configurationService: configurationService)

        let first = try await service.imagesConfiguration()
        let second = try await service.imagesConfiguration()

        #expect(first == expectedResult)
        #expect(second == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("URL for a specific size resolves against the fetched configuration")
    func urlForSpecificSizeResolvesAgainstFetchedConfiguration() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, configurationService) = Self.makeService(configuration: configuration)
        let path = try #require(URL(string: "/image.jpg"))

        let poster = try await service.posterURL(for: path, size: .width(500))
        let backdrop = try await service.backdropURL(for: path, size: .width(780))
        let logo = try await service.logoURL(for: path, size: .width(154))
        let profile = try await service.profileURL(for: path, size: .height(632))
        let still = try await service.stillURL(for: path, size: .width(185))

        #expect(poster == URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))
        #expect(backdrop == URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))
        #expect(logo == URL(string: "https://image.tmdb.org/t/p/w154/image.jpg"))
        #expect(profile == URL(string: "https://image.tmdb.org/t/p/h632/image.jpg"))
        #expect(still == URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("URL for an ideal width picks the smallest size at least that wide")
    func urlForIdealWidthPicksSmallestSizeAtLeastThatWide() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, configurationService) = Self.makeService(configuration: configuration)
        let path = try #require(URL(string: "/image.jpg"))

        let poster = try await service.posterURL(for: path, idealWidth: 300)
        let backdrop = try await service.backdropURL(for: path, idealWidth: 500)
        let logo = try await service.logoURL(for: path, idealWidth: 100)
        let profile = try await service.profileURL(for: path, idealWidth: 50)
        let still = try await service.stillURL(for: path, idealWidth: 200)

        #expect(poster == URL(string: "https://image.tmdb.org/t/p/w342/image.jpg"))
        #expect(backdrop == URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))
        #expect(logo == URL(string: "https://image.tmdb.org/t/p/w154/image.jpg"))
        #expect(profile == URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))
        #expect(still == URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("URL with no ideal width defaults to the original image")
    func urlWithNoIdealWidthDefaultsToOriginal() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, _) = Self.makeService(configuration: configuration)
        let path = try #require(URL(string: "/image.jpg"))

        let poster = try await service.posterURL(for: path)

        #expect(poster == URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))
    }

    @Test("URL for a nil path returns nil without fetching the configuration")
    func urlForNilPathReturnsNilWithoutFetching() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, configurationService) = Self.makeService(configuration: configuration)

        let poster = try await service.posterURL(for: nil, size: .width(500))
        let backdrop = try await service.backdropURL(for: nil)
        let logo = try await service.logoURL(for: nil, size: .width(154))
        let profile = try await service.profileURL(for: nil)
        let still = try await service.stillURL(for: nil, size: .width(185))

        #expect(poster == nil)
        #expect(backdrop == nil)
        #expect(logo == nil)
        #expect(profile == nil)
        #expect(still == nil)

        // A model with no image must never cost a network request, and must never
        // surface a network error — rendering a list of placeholders offline would
        // otherwise produce one error per missing image.
        #expect(configurationService.apiConfigurationCallCount == 0)
    }

    @Test("URL for an unsupported size returns nil")
    func urlForUnsupportedSizeReturnsNil() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, configurationService) = Self.makeService(configuration: configuration)
        let path = try #require(URL(string: "/image.jpg"))

        let poster = try await service.posterURL(for: path, size: .width(999))

        #expect(poster == nil)

        // Unlike the nil-path case, this one must consult the configuration to
        // know the size is unsupported.
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("preload fetches the configuration once, and later URLs reuse it")
    func preloadFetchesOnceAndLaterURLsReuseIt() async throws {
        let configuration = try Self.makeConfiguration()
        let (service, configurationService) = Self.makeService(configuration: configuration)
        let path = try #require(URL(string: "/image.jpg"))

        try await service.preload()
        #expect(configurationService.apiConfigurationCallCount == 1)

        let poster = try await service.posterURL(for: path, size: .width(500))

        #expect(poster == URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("refresh fetches the configuration again")
    func refreshFetchesConfigurationAgain() async throws {
        let first = try Self.makeConfiguration()
        let second = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://cdn.tmdb.org/t/p/")),
            backdropSizes: ["original"],
            logoSizes: ["original"],
            posterSizes: ["original"],
            profileSizes: ["original"],
            stillSizes: ["original"]
        )
        let configurationService = CountingConfigurationService()
        configurationService.enqueue(.success(.mock(images: first)))
        configurationService.enqueue(.success(.mock(images: second)))
        let service = TMDbImageService(configurationService: configurationService)

        let before = try await service.imagesConfiguration()
        let refreshed = try await service.refresh()
        let after = try await service.imagesConfiguration()

        #expect(before == first)
        #expect(refreshed == second)
        #expect(after == second)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

}
