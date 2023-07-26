import TMDb
import XCTest

final class MovieIntegrationTests: XCTestCase {

    var movieService: MovieService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        movieService = MovieService()
    }

    override func tearDown() {
        movieService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let movieID = 346698

        let movie = try await movieService.details(forMovie: movieID)

        XCTAssertEqual(movie.id, movieID)
        XCTAssertEqual(movie.title, "Barbie")
    }

}
