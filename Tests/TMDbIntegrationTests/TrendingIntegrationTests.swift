import TMDb
import XCTest

final class TrendingIntegrationTests: XCTestCase {

    var trendingService: TrendingService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        trendingService = TrendingService()
    }
    
    override func tearDown() {
        trendingService = nil
        super.tearDown()
    }

    func testMoviesTrendingByDay() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .day)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testMoviesTrendingByWeek() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .week)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testTVShowsTrendingByDay() async throws {
        let tvShowList = try await trendingService.tvShows(inTimeWindow: .day)

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

    func testTVShowTrendingByWeek() async throws {
        let tvShowList = try await trendingService.tvShows(inTimeWindow: .week)

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

    func testPeopleTrendingByDay() async throws {
        let personList = try await trendingService.people(inTimeWindow: .day)

        XCTAssertFalse(personList.results.isEmpty)
    }

    func testPeopleTrendingByWeek() async throws {
        let personList = try await trendingService.people(inTimeWindow: .week)

        XCTAssertFalse(personList.results.isEmpty)
    }

}
