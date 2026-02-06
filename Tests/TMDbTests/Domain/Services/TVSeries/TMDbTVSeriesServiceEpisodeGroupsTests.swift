//
//  TMDbTVSeriesServiceEpisodeGroupsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceEpisodeGroupsTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("episodeGroups returns episode group collection")
    func episodeGroupsReturnsCollection() async throws {
        let expectedResult = TVEpisodeGroupCollection.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesEpisodeGroupsRequest(id: tvSeriesID)

        let result = try await service.episodeGroups(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeriesEpisodeGroupsRequest == expectedRequest
        )
    }

    @Test("episodeGroups when errors throws error")
    func episodeGroupsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.episodeGroups(forTVSeries: tvSeriesID)
        }
    }

    @Test("JSON decoding of TVEpisodeGroupCollection", .tags(.decoding))
    func decodeTVEpisodeGroupCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeGroupCollection.self,
            fromResource: "tv-series-episode-groups"
        )

        #expect(result.id == 1399)
        #expect(result.episodeGroups.count == 1)
        #expect(result.episodeGroups[0].id == "5acf93e60e0a26346c00000b")
        #expect(result.episodeGroups[0].name == "Aired Order")

        let episodeCount = try #require(result.episodeGroups[0].episodeCount)
        #expect(episodeCount == 73)

        let groupCount = try #require(result.episodeGroups[0].groupCount)
        #expect(groupCount == 8)

        let type = try #require(result.episodeGroups[0].type)
        #expect(type == 1)
    }

}
