// @testable import TMDb
// import XCTest
//
// final class DiscoverTests: XCTestCase {
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
//    func testMovies() async throws {
//        TMDbURLProtocol.add("discover-movie", for: DiscoverEndpoint.movies())
//
//        let movieList = try await tmdb.discover.movies()
//
//        XCTAssertTrue(!movieList.results.isEmpty)
//    }
//
//    func testTVShows() async throws {
//        TMDbURLProtocol.add("discover-tv", for: DiscoverEndpoint.tvShows())
//
//        let tvShowList = try await tmdb.discover.tvShows()
//
//        XCTAssertTrue(!tvShowList.results.isEmpty)
//    }
//
// }
