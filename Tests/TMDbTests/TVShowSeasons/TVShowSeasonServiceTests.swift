@testable import TMDb
import XCTest

final class TVShowSeasonServiceTests: XCTestCase {

    var service: TVShowSeasonService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = TVShowSeasonService(apiClient: apiClient, localeProvider: { [unowned self] in locale })
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVShowSeason() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowSeason.mock()
        let seasonNumber = expectedResult.seasonNumber
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forSeason: seasonNumber, inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber).path)
    }

    func testImagesReturnsImages() async throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = TVShowSeasonImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forSeason: seasonNumber, inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                         languageCode: locale.languageCode).path
        )
    }

    func testVideosReturnsVideos() async throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forSeason: seasonNumber, inTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber,
                                         languageCode: locale.languageCode).path
        )
    }

}
