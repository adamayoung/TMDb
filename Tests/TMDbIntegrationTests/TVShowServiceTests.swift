import TMDb
import XCTest

final class TVShowServiceTests: XCTestCase {
    
    var tvShowService: TVShowService!
    
    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        tvShowService = TVShowService()
    }
    
    override func tearDown() {
        tvShowService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let tvShowID = 84958

        let tvShow = try await tvShowService.details(forTVShow: tvShowID)

        XCTAssertEqual(tvShow.id, tvShowID)
        XCTAssertEqual(tvShow.name, "Loki")
    }

    func testCredits() async throws {
        let tvShowID = 4604

        let credits = try await tvShowService.credits(forTVShow: tvShowID)

        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testReviews() async throws {
        let tvShowID = 76479

        let reviewList = try await tvShowService.reviews(forTVShow: tvShowID)

        XCTAssertFalse(reviewList.results.isEmpty)
    }

    func testImages() async throws {
        let tvShowID = 76479

        let imageCollection = try await tvShowService.images(forTVShow: tvShowID)

        XCTAssertEqual(imageCollection.id, tvShowID)
        XCTAssertFalse(imageCollection.backdrops.isEmpty)
        XCTAssertFalse(imageCollection.logos.isEmpty)
        XCTAssertFalse(imageCollection.posters.isEmpty)
    }

    func testVideos() async throws {
        let tvShowID = 76479

        let videoCollection = try await tvShowService.videos(forTVShow: tvShowID)

        XCTAssertEqual(videoCollection.id, tvShowID)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

    func testRecommendations() async throws {
        let tvShowID = 76479

        let tvShowList = try await tvShowService.recommendations(forTVShow: tvShowID)

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

    func testSimilar() async throws {
        let tvShowID = 76479

        let tvShowList = try await tvShowService.similar(toTVShow: tvShowID)

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

    func testPopular() async throws {
        let tvShowList = try await tvShowService.popular()

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

}
