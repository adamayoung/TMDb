// @testable import TMDb
// import XCTest
//
// final class GenreTests: XCTestCase {
//
//    private var tmdb: TMDbAPI!
//
//    override func setUpWithError() throws {
//        super.setUp()
//        tmdb = TMDbAPI(apiKey: "", urlSessionConfiguration: .integrationTest)
//    }
//
//    override func tearDown() {
//        tmdb = nil
//        TMDbURLProtocol.reset()
//        super.tearDown()
//    }
//
//    func testMovieGenres() async throws {
//        TMDbURLProtocol.add("genre-movie-list", for: GenresEndpoint.movie)
//
//        let genres = try await tmdb.genres.movieGenres()
//
//        XCTAssertTrue(!genres.isEmpty)
//    }
//
//    func testTVShowGenres() async throws {
//        TMDbURLProtocol.add("genre-tv-list", for: GenresEndpoint.tvShow)
//
//        let genres = try await tmdb.genres.tvShowGenres()
//
//        XCTAssertTrue(!genres.isEmpty)
//    }
//
// }
