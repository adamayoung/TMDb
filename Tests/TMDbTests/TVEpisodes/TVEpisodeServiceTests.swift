@testable import TMDb
import XCTest

final class TVEpisodeServiceTests: XCTestCase {

    var service: TVEpisodeService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = TVEpisodeService(apiClient: apiClient, localeProvider: { [unowned self] in locale })
    }

    override func tearDown() {
        apiClient = nil
        locale = nil
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
                                                 languageCode: locale.languageCode).path)
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
                                                 languageCode: locale.languageCode).path)
    }

}
