import Combine
@testable import TMDb
import XCTest

class TMDbAPITVShowTests: TMDbAPITestCase {

    func testDetailsPublisherForTVShowReturnsTVShow() throws {
        let expectedResult = TVShow(id: 1, name: "Name 1")
        tvShowService.tvShowDetails = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.detailsPublisher(forTVShow: expectedTVShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastTVShowDetailsID, expectedTVShowID)
    }

    func testCreditsPublisherForTVShowReturnsShowCredits() throws {
        let expectedResult = ShowCredits(
            id: 1,
            cast: [
                CastMember(
                    id: 2,
                    creditID: "3",
                    name: "Cast 1",
                    character: "Character 1",
                    order: 0
                ),
                CastMember(
                    id: 3,
                    creditID: "4",
                    name: "Cast 2",
                    character: "Character 2",
                    order: 1
                )
            ],
            crew: [
                CrewMember(
                    id: 4,
                    creditID: "5",
                    name: "Crew 1",
                    job: "Job 1",
                    department: "Department 1"
                ),
                CrewMember(
                    id: 5,
                    creditID: "6",
                    name: "Crew 2",
                    job: "Job 2",
                    department: "Department 2"
                )
            ]
        )
        tvShowService.credits = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.creditsPublisher(forTVShow: expectedTVShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastCreditsTVShowID, expectedTVShowID)
    }

    func testReviewsPublisherForTVShowReturnsReviews() throws {
        let expectedResult = ReviewPageableList(
            page: 2,
            results: [
                Review(id: "1", author: "Author 1", content: "Content 1"),
                Review(id: "2", author: "Author 2", content: "Content 2"),
                Review(id: "3", author: "Author 3", content: "Content 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.reviews = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.reviewsPublisher(forTVShow: expectedTVShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastReviewsTVShowID, expectedTVShowID)
    }

    func testImagesPublisherForTVShowReturnsImages() throws {
        let expectedResult = ImageCollection(
            id: 1,
            posters: [
                ImageMetadata(filePath: URL(string: "/some/image1")!, width: 100, height: 100),
                ImageMetadata(filePath: URL(string: "/some/image2")!, width: 200, height: 200),
                ImageMetadata(filePath: URL(string: "/some/image3")!, width: 300, height: 300)
            ],
            backdrops: [
                ImageMetadata(filePath: URL(string: "/some/image4")!, width: 400, height: 400),
                ImageMetadata(filePath: URL(string: "/some/image5")!, width: 500, height: 500),
                ImageMetadata(filePath: URL(string: "/some/image6")!, width: 600, height: 600)
            ]
        )
        tvShowService.images = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.imagesPublisher(forTVShow: expectedTVShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastImagesTVShowID, expectedTVShowID)
    }

    func testVideosPublisherForTVShowReturnsVideos() throws {
        let expectedResult = VideoCollection(
            id: 1,
            results: [
                VideoMetadata(
                    id: "1", name: "Name 1",
                    site: "Site 1",
                    key: "key1",
                    type: .teaser,
                    size: .s1080
                )
            ]
        )
        tvShowService.videos = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.videosPublisher(forTVShow: expectedTVShowID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastVideosTVShowID, expectedTVShowID)
    }

    func testRecommendationsPublisherForTVShowReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.recommendations = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.recommendationsPublisher(forTVShow: expectedTVShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastRecommendationsTVShowID, expectedTVShowID)
        XCTAssertNil(tvShowService.lastRecommendationsPage)
    }

    func testRecommendationsPublisherForTVShowWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.recommendations = expectedResult
        let expectedTVShowID: TVShow.ID = 1
        let expectedPage = 2

        let result = try await(publisher: tmdb.recommendationsPublisher(forTVShow: expectedTVShowID,
                                                                        page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastRecommendationsTVShowID, expectedTVShowID)
        XCTAssertEqual(tvShowService.lastRecommendationsPage, expectedPage)
    }

    func testTVShowsPublisherSimilarToTVShowReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.similar = expectedResult
        let expectedTVShowID: TVShow.ID = 1

        let result = try await(publisher: tmdb.tvShowsPublisher(similarToTVShow: expectedTVShowID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastSimilarTVShowID, expectedTVShowID)
        XCTAssertNil(tvShowService.lastSimilarPage)
    }

    func testTVShowsPublisherSimilarToTVShowWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.similar = expectedResult
        let expectedTVShowID: TVShow.ID = 1
        let expectedPage = 2

        let result = try await(publisher: tmdb.tvShowsPublisher(similarToTVShow: expectedTVShowID, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastSimilarTVShowID, expectedTVShowID)
        XCTAssertEqual(tvShowService.lastSimilarPage, expectedPage)
    }

    func testPopularTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.popular = expectedResult

        let result = try await(publisher: tmdb.popularTVShowsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertNil(tvShowService.lastPopularPage)
    }

    func testPopularTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        tvShowService.popular = expectedResult
        let expectedPage = 2

        let result = try await(publisher: tmdb.popularTVShowsPublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(tvShowService.lastPopularPage, expectedPage)
    }

}
