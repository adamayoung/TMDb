#if swift(>=5.5)
@testable import TMDb
import XCTest

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
final class TMDbTVShowServiceAsyncAwaitTests: XCTestCase {

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
        let expectedResult = TVShow.mock
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).url)
    }

    func testCreditsReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.credits(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).url)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).url)
    }

    func testImagesReturnsImages() async throws {
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).url)
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock
        let tvShowID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).url)
    }

    func testRecommendationsWithDefaultParametersReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsWithPageReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).url)
    }

    func testSimilarWithDefaultParametersReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarWithPageReturnsTVShows() async throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVShow: tvShowID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).url)
    }

    func testPopularWithDefaultParametersReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularWithPageReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).url)
    }

}
#endif
