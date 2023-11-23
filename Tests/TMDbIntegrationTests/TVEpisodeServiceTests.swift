import TMDb
import XCTest

final class TVEpisodeServiceTests: XCTestCase {

    var tvEpisodeService: TVEpisodeService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        tvEpisodeService = TVEpisodeService()
    }

    override func tearDown() {
        tvEpisodeService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let episode = try await tvEpisodeService.details(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                         inTVSeries: tvSeriesID)

        XCTAssertEqual(episode.id, 63068)
        XCTAssertEqual(episode.episodeNumber, episodeNumber)
        XCTAssertEqual(episode.seasonNumber, seasonNumber)
        XCTAssertEqual(episode.name, "What is Dead May Never Die")
    }

    func testImages() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let imageCollection = try await tvEpisodeService.images(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                                inTVSeries: tvSeriesID)

        XCTAssertEqual(imageCollection.id, 63068)
        XCTAssertFalse(imageCollection.stills.isEmpty)
    }

    func testVideos() async throws {
        let episodeNumber = 3
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvEpisodeService.videos(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                                inTVSeries: tvSeriesID)

        XCTAssertEqual(videoCollection.id, 63058)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
