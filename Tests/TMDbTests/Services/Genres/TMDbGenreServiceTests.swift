@testable import TMDb
import XCTest

final class TMDbGenreServiceTests: XCTestCase {

    var service: TMDbGenreService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbGenreService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMovieGenresReturnsGenres() async throws {
        let genreList = GenreList.mock
        let expectedResult = genreList.genres
        apiClient.result = .success(genreList)

        let result = try await service.movieGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, GenresEndpoint.movies.path)
    }

}
