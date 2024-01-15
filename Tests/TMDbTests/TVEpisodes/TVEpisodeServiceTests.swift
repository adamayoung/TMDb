@testable import TMDb
import XCTest

final class TVEpisodeServiceTests: XCTestCase {

    var service: TVEpisodeService!
    var apiClient: MockAPIClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        service = TVEpisodeService(apiClient: apiClient, localeProvider: localeProvider)
    }

    override func tearDown() {
        apiClient = nil
        localeProvider = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeason() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forEpisode: episodeNumber,
                                               inSeason: seasonNumber,
                                               inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVEpisodesEndpoint.details(tvSeriesID: tvSeriesID,
                                                  seasonNumber: seasonNumber,
                                                  episodeNumber: episodeNumber).path)
    }

    func testImagesReturnsImages() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = TVEpisodeImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forEpisode: episodeNumber,
                                              inSeason: seasonNumber,
                                              inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVEpisodesEndpoint.images(tvSeriesID: tvSeriesID,
                                                 seasonNumber: seasonNumber,
                                                 episodeNumber: episodeNumber,
                                                 languageCode: localeProvider.languageCode).path)
    }

    func testVideosReturnsVideos() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forEpisode: episodeNumber,
                                              inSeason: seasonNumber,
                                              inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVEpisodesEndpoint.videos(tvSeriesID: tvSeriesID,
                                                 seasonNumber: seasonNumber,
                                                 episodeNumber: episodeNumber,
                                                 languageCode: localeProvider.languageCode).path)
    }

}
