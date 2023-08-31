import TMDb
import XCTest

final class GenreIntegrationTests: XCTestCase {

    var genreService: GenreService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        genreService = GenreService()
    }

    override func tearDown() {
        genreService = nil
        super.tearDown()
    }

    func testMovieGenres() async throws {
        let genres = try await genreService.movieGenres()

        XCTAssertFalse(genres.isEmpty)
    }

    func testTVShowGenres() async throws {
        let genres = try await genreService.tvShowGenres()

        XCTAssertFalse(genres.isEmpty)
    }

}
