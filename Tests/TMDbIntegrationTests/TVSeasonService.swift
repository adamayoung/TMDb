import TMDb
import XCTest

final class TVSeasonServiceTests: XCTestCase {

    var tvSeasonService: TVSeasonService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        tvSeasonService = TVSeasonService()
    }

    override func tearDown() {
        tvSeasonService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let season = try await tvSeasonService.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertEqual(season.seasonNumber, seasonNumber)
        XCTAssertFalse((season.episodes ?? []).isEmpty)
    }

    func testImages() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvSeasonService.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
