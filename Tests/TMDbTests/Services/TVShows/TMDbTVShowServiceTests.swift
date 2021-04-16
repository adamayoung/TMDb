@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbTVShowServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbTVShowService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbTVShowService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

}

#if canImport(Combine)
extension TMDbTVShowServiceTests {

    func testDetailsPublisherReturnsTVShow() throws {
        let expectedResult = TVShow.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).url)
    }

    func testCreditsPublisherReturnsShowsCredits() throws {
        let expectedResult = ShowCredits.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.creditsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherWithPageReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).url)
    }

    func testImagesPublisherReturnsImages() throws {
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.imagesPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).url)
    }

    func testVideosPublisherReturnsVideos() throws {
        let expectedResult = VideoCollection.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.videosPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).url)
    }

    func testSimilarPublisherReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarPublisherWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).url)
    }

    func testPopularPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).url)
    }

}
#endif
