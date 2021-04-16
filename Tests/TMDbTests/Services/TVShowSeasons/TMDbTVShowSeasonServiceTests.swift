@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbTVShowSeasonServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbTVShowSeasonService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbTVShowSeasonService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

}

#if canImport(Combine)
extension TMDbTVShowSeasonServiceTests {

    func testDetailsPublisherReturnsTVShowSeason() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowSeason.mock
        let seasonNumber = expectedResult.seasonNumber
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
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

        let result = try await(publisher: service.imagesPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
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

        let result = try await(publisher: service.videosPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

}
#endif
