#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbTVShowSeasonServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbTVShowSeasonService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTVShowSeasonService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsPublisherReturnsTVShowSeason() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowSeason.mock
        let seasonNumber = expectedResult.seasonNumber
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.detailsPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testImagesPublisherReturnsImages() throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.imagesPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testVideosPublisherReturnsVideos() throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = VideoCollection.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.videosPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

}
#endif
