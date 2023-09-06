@testable import TMDb
import XCTest

final class GenreServiceTests: XCTestCase {

    var service: GenreService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = GenreService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMovieGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.result = .success(genreList)

        let result = try await service.movieGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, GenresEndpoint.movie.path)
    }

    func testTVSeriesGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.result = .success(genreList)

        let result = try await service.tvSeriesGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, GenresEndpoint.tvSeries.path)
    }

}
