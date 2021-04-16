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
        let seasonNumber = 1
        let tvShowID = 2
        let expectedResult = TVShowSeason(
            id: 11,
            name: "Season 1",
            seasonNumber: seasonNumber
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testImagesPublisherReturnsImages() throws {
        let seasonNumber = 1
        let tvShowID = 2
        let expectedResult = ImageCollection(
            id: 1,
            posters: [
                ImageMetadata(filePath: URL(string: "/some/path/1.jpg")!, width: 100, height: 200),
                ImageMetadata(filePath: URL(string: "/some/path/2.jpg")!, width: 200, height: 400)
            ],
            backdrops: [
                ImageMetadata(filePath: URL(string: "/some/path/3.jpg")!, width: 200, height: 100),
                ImageMetadata(filePath: URL(string: "/some/path/4.jpg")!, width: 400, height: 200)
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.imagesPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testVideosPublisherReturnsVideos() throws {
        let seasonNumber = 1
        let tvShowID = 2
        let expectedResult = VideoCollection(
            id: 1,
            results: [
                VideoMetadata(id: "1", name: "Video 1", site: "Site 1", key: "Key 1", type: .trailer, size: .s1080),
                VideoMetadata(id: "2", name: "Video 2", site: "Site 2", key: "Key 2", type: .clip, size: .s720),
                VideoMetadata(id: "3", name: "Video 3", site: "Site 3", key: "Key 3", type: .teaser, size: .s480)
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.videosPublisher(forSeason: seasonNumber, inTVShow: tvShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

}
#endif
