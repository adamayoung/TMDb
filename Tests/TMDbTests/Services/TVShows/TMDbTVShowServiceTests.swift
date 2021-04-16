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
        let tvShowID = 1
        let expectedResult = TVShow(id: 1, name: "TV Show 1")
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).url)
    }

    func testCreditsPublisherReturnsShowsCredits() throws {
        let tvShowID = 1
        let expectedResult = ShowCredits(
            id: 1,
            cast: [
                CastMember(id: 1, creditID: "a", name: "Cast 1", character: "Character 1", order: 0),
                CastMember(id: 2, creditID: "b", name: "Cast 2", character: "Character 2", order: 1)
            ],
            crew: [
                CrewMember(id: 3, creditID: "c", name: "Crew 1", job: "Job 1", department: "Department 1"),
                CrewMember(id: 4, creditID: "d", name: "Crew 2", job: "Job 2", department: "Department 2")
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.creditsPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherReturnsReviews() throws {
        let tvShowID = 1
        let expectedResult = ReviewPageableList(
            page: 1,
            results: [
                Review(id: "1", author: "Author 1", content: "Content 1"),
                Review(id: "2", author: "Author 2", content: "Content 2"),
                Review(id: "3", author: "Author 3", content: "Content 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testReviewsPublisherWithPageReturnsReviews() throws {
        let tvShowID = 1
        let page = 2
        let expectedResult = ReviewPageableList(
            page: 2,
            results: [
                Review(id: "4", author: "Author 4", content: "Content 4"),
                Review(id: "5", author: "Author 5", content: "Content 5"),
                Review(id: "6", author: "Author 6", content: "Content 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).url)
    }

    func testImagesPublisherReturnsImages() throws {
        let tvShowID = 1
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

        let result = try await(publisher: service.imagesPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).url)
    }

    func testVideosPublisherReturnsVideos() throws {
        let tvShowID = 1
        let expectedResult = VideoCollection(
            id: 1,
            results: [
                VideoMetadata(id: "1", name: "Video 1", site: "Site 1", key: "Key 1", type: .trailer, size: .s1080),
                VideoMetadata(id: "2", name: "Video 2", site: "Site 2", key: "Key 2", type: .clip, size: .s720),
                VideoMetadata(id: "3", name: "Video 3", site: "Site 3", key: "Key 3", type: .teaser, size: .s480)
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.videosPublisher(forTVShow: tvShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherReturnsTVShows() throws {
        let tvShowID = 1
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testRecommendationsPublisherWithPageReturnsTVShows() throws {
        let tvShowID = 1
        let page = 2
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 4, name: "TV Show 4"),
                TVShow(id: 5, name: "TV Show 5"),
                TVShow(id: 6, name: "TV Show 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).url)
    }

    func testSimilarPublisherReturnsTVShows() throws {
        let tvShowID = 1
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toTVShow: tvShowID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testSimilarPublisherWithPageReturnsTVShows() throws {
        let tvShowID = 1
        let page = 2
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 4, name: "TV Show 4"),
                TVShow(id: 5, name: "TV Show 5"),
                TVShow(id: 6, name: "TV Show 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toTVShow: tvShowID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).url)
    }

    func testPopularPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsTVShows() throws {
        let page = 2
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 4, name: "TV Show 4"),
                TVShow(id: 5, name: "TV Show 5"),
                TVShow(id: 6, name: "TV Show 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).url)
    }

}
#endif
