@testable import TMDb
import XCTest

final class TMDbTVShowEpisodeServiceTests: XCTestCase {

    var service: TMDbTVShowEpisodeService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTVShowEpisodeService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVShowSeason() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forEpisode: episodeNumber,
                                               inSeason: seasonNumber,
                                               inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowEpisodesEndpoint.details(tvShowID: tvShowID,
                                                      seasonNumber: seasonNumber,
                                                      episodeNumber: episodeNumber).path)
    }

    func testImagesReturnsImages() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = TVShowEpisodeImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forEpisode: episodeNumber,
                                              inSeason: seasonNumber,
                                              inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowEpisodesEndpoint.images(tvShowID: tvShowID,
                                                     seasonNumber: seasonNumber,
                                                     episodeNumber: episodeNumber).path)
    }

    func testVideosReturnsVideos() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forEpisode: episodeNumber,
                                              inSeason: seasonNumber,
                                              inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowEpisodesEndpoint.videos(tvShowID: tvShowID,
                                                     seasonNumber: seasonNumber,
                                                     episodeNumber: episodeNumber).path)
    }

}
