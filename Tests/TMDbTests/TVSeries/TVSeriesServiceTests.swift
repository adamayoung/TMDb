@testable import TMDb
import XCTest

final class TVSeriesServiceTests: XCTestCase {

    var service: TVSeriesService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = TVSeriesService(apiClient: apiClient, localeProvider: { [unowned self] in locale })
    }

    override func tearDown() {
        apiClient = nil
        locale = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path)
    }

    func testCreditsReturnsShowsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.credits(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.credits(tvSeriesID: tvSeriesID).path)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID).path)
    }

    func testReviewsReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID).path)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.reviews(tvSeriesID: tvSeriesID, page: page).path)
    }

    func testImagesReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVSeriesEndpoint.images(tvSeriesID: tvSeriesID, languageCode: locale.languageCode).path
        )
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            TVSeriesEndpoint.videos(tvSeriesID: tvSeriesID, languageCode: locale.languageCode).path
        )
    }

    func testRecommendationsWithDefaultParametersReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID).path)
    }

    func testRecommendationsReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID).path)
    }

    func testRecommendationsWithPageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.recommendations(tvSeriesID: tvSeriesID, page: page).path)
    }

    func testSimilarWithDefaultParametersReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID).path)
    }

    func testSimilarReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVSeries: tvSeriesID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID).path)
    }

    func testSimilarWithPageReturnsTVSeries() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toTVSeries: tvSeriesID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.similar(tvSeriesID: tvSeriesID, page: page).path)
    }

    func testPopularWithDefaultParametersReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.popular().path)
    }

    func testPopularReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.popular().path)
    }

    func testPopularWithPageReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.popular(page: page).path)
    }

    func testWatchReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let tvSeriesID = 1
        apiClient.result = .success(expectedResult)

        let result = try await service.watchProviders(forTVSeries: tvSeriesID)

        let regionCode = try XCTUnwrap(locale.regionCode)
        XCTAssertEqual(result, expectedResult.results[regionCode])
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.watch(tvSeriesID: tvSeriesID).path)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = TVSeriesExternalLinksCollection.lockeAndKey
        let tvSeriesID = 86423
        apiClient.result = .success(expectedResult)

        let result = try await service.externalLinks(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVSeriesEndpoint.externalIDs(tvSeriesID: tvSeriesID).path)
    }

}
