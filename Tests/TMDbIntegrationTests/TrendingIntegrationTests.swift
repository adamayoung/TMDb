import TMDb
import XCTest

final class TrendingIntegrationTests: XCTestCase {

    var trendingService: TrendingService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
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

    func testTVSeriesTrendingByDay() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .day)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testTVSeriesTrendingByWeek() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .week)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
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
