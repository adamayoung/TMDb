import TMDb
import XCTest

final class TVShowSeasonServiceTests: XCTestCase {
    
    var tvShowSeasonService: TVShowSeasonService!
    
    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        tvShowSeasonService = TVShowSeasonService()
    }
    
    override func tearDown() {
        tvShowSeasonService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let seasonNumber = 2
        let tvShowID = 1399

        let season = try await tvShowSeasonService.details(forSeason: seasonNumber, inTVShow: tvShowID)

        XCTAssertEqual(season.seasonNumber, seasonNumber)
        XCTAssertFalse((season.episodes ?? []).isEmpty)
    }

    func testImages() async throws {
        let seasonNumber = 1
        let tvShowID = 1399

        let videoCollection = try await tvShowSeasonService.videos(forSeason: seasonNumber, inTVShow: tvShowID)

        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
