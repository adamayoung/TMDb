#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbTVShowServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testDetailsPublisherReturnsTVShow() throws {
        let expectedResult = TVShow.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.detailsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).url)
    }

    func testCreditsPublisherReturnsShowsCredits() throws {
        let expectedResult = ShowCredits.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.creditsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherWithDefaultParametersReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherWithPageReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).url)
    }

    func testImagesPublisherReturnsImages() throws {
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.imagesPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).url)
    }

    func testVideosPublisherReturnsVideos() throws {
        let expectedResult = VideoCollection.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.videosPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherWithDefaultParametersReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forTVShow: tvShowID),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).url)
    }

    func testSimilarPublisherWithDefaultParametersReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarPublisherReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarPublisherWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).url)
    }

    func testPopularPublisherWithDefaultParametersReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).url)
    }

}
#endif
