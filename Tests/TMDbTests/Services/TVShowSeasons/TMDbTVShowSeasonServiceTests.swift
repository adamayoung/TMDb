@testable import TMDb
import XCTest

final class TMDbTVShowSeasonServiceTests: XCTestCase {

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

    func testFetchDetailsReturnsTVShowSeason() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowSeason.mock
        let seasonNumber = expectedResult.seasonNumber
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchDetails(forSeason: seasonNumber, inTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testFetchImagesReturnsImages() throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchImages(forSeason: seasonNumber, inTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

    func testFetchVideosReturnsVideos() throws {
        let seasonNumber = Int.randomID
        let tvShowID = Int.randomID
        let expectedResult = VideoCollection.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchVideos(forSeason: seasonNumber, inTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath,
                       TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber).url)
    }

}
