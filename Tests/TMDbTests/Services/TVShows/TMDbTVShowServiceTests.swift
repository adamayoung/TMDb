@testable import TMDb
import XCTest

final class TMDbTVShowServiceTests: XCTestCase {

    var service: TMDbTVShowService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTVShowService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVShow() async throws {
        let expectedResult = TVShow.theSandman
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).path)
    }

    func testCreditsReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.credits(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).path)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).path)
    }

    func testReviewsReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).path)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).path)
    }

    func testImagesReturnsImages() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).path)
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).path)
    }

    func testRecommendationsWithDefaultParametersReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).path)
    }

    func testRecommendationsReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).path)
    }

    func testRecommendationsWithPageReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).path)
    }

    func testSimilarWithDefaultParametersReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).path)
    }

    func testSimilarReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).path)
    }

    func testSimilarWithPageReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).path)
    }

    func testPopularWithDefaultParametersReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().path)
    }

    func testPopularReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().path)
    }

    func testPopularWithPageReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).path)
    }

}
