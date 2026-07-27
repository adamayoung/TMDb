//
//  MockImageServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .images))
struct MockImageServiceTests {

    var service: MockImageService

    init() {
        self.service = MockImageService()
    }

    @Test("imagesConfiguration by default returns the sample configuration")
    func imagesConfigurationByDefaultReturnsSample() async throws {
        let result = try await service.imagesConfiguration()

        #expect(result == ImagesConfiguration.sample)
    }

    @Test("imagesConfiguration records the call")
    func imagesConfigurationRecordsCall() async throws {
        _ = try await service.imagesConfiguration()

        #expect(service.imagesConfigurationCalls.count == 1)
    }

    @Test("imagesConfiguration throws the injected failure")
    func imagesConfigurationThrowsInjectedFailure() async {
        service.imagesConfigurationResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.imagesConfiguration()
        }
    }

    @Test("imagesConfiguration returns the injected success value")
    func imagesConfigurationReturnsInjectedSuccess() async throws {
        let injected = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://example.com/")),
            secureBaseURL: #require(URL(string: "https://example.com/")),
            backdropSizes: ["original"],
            logoSizes: ["original"],
            posterSizes: ["original"],
            profileSizes: ["original"],
            stillSizes: ["original"]
        )
        service.imagesConfigurationResult = .success(injected)

        let result = try await service.imagesConfiguration()

        #expect(result == injected)
    }

    @Test("refresh by default returns the sample configuration")
    func refreshByDefaultReturnsSample() async throws {
        let result = try await service.refresh()

        #expect(result == ImagesConfiguration.sample)
    }

    @Test("refresh records the call")
    func refreshRecordsCall() async throws {
        _ = try await service.refresh()

        #expect(service.refreshCalls.count == 1)
    }

    @Test("refresh throws the injected failure")
    func refreshThrowsInjectedFailure() async {
        service.refreshResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.refresh()
        }
    }

    @Test("URL methods resolve against the stubbed configuration")
    func urlMethodsResolveAgainstStubbedConfiguration() async throws {
        let path = try #require(URL(string: "/image.jpg"))

        let poster = try await service.posterURL(for: path, size: .width(500))

        #expect(poster == URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))
    }

    @Test("concurrent calls over one instance record every call without racing")
    func concurrentCallsAreThreadSafe() async {
        let iterations = 100

        await withTaskGroup(of: Void.self) { group in
            for _ in 0 ..< iterations {
                group.addTask {
                    _ = try? await service.imagesConfiguration()
                }
            }
        }

        #expect(service.imagesConfigurationCalls.count == iterations)
    }

}
