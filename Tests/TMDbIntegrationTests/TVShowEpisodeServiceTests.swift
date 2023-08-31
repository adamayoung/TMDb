import TMDb
import XCTest

final class TVShowEpisodeServiceTests: XCTestCase {

    var tvShowEpisodeService: TVShowEpisodeService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        tvShowEpisodeService = TVShowEpisodeService()
    }

    override func tearDown() {
        tvShowEpisodeService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvShowID = 1399

        let episode = try await tvShowEpisodeService.details(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                             inTVShow: tvShowID)

        XCTAssertEqual(episode.id, 63068)
        XCTAssertEqual(episode.episodeNumber, episodeNumber)
        XCTAssertEqual(episode.seasonNumber, seasonNumber)
        XCTAssertEqual(episode.name, "What is Dead May Never Die")
    }

    func testImages() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvShowID = 1399

        let imageCollection = try await tvShowEpisodeService.images(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                                    inTVShow: tvShowID)

        XCTAssertEqual(imageCollection.id, 63068)
        XCTAssertFalse(imageCollection.stills.isEmpty)
    }

    func testVideos() async throws {
        let episodeNumber = 3
        let seasonNumber = 1
        let tvShowID = 1399

        let videoCollection = try await tvShowEpisodeService.videos(forEpisode: episodeNumber, inSeason: seasonNumber,
                                                                    inTVShow: tvShowID)

        XCTAssertEqual(videoCollection.id, 63058)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
