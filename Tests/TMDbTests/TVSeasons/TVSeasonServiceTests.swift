@testable import TMDb
import XCTest

final class TVSeasonServiceTests: XCTestCase {

    var service: TVSeasonService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = TVSeasonService(apiClient: apiClient, localeProvider: { [unowned self] in locale })
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeason() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVSeasonsEndpoint.details(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber).path)
    }

    func testImagesReturnsImages() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeasonImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVSeasonsEndpoint.images(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber,
                                         languageCode: locale.languageCode).path
        )
    }

    func testVideosReturnsVideos() async throws {
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVSeasonsEndpoint.videos(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber,
                                         languageCode: locale.languageCode).path
        )
    }

}
