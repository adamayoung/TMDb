import TMDb
import XCTest

final class SearchIntegrationTests: XCTestCase {

    var searchService: SearchService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        searchService = SearchService()
    }

    override func tearDown() {
        searchService = nil
        super.tearDown()
    }

    func testSearchAll() async throws {
        let query = "barbie"

        let mediaList = try await searchService.searchAll(query: query)

        XCTAssertFalse(mediaList.results.isEmpty)
    }

    func testSearchMovies() async throws {
        let query = "avengers"

        let movieList = try await searchService.searchMovies(query: query)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testSearchTVSeries() async throws {
        let query = "game of thrones"

        let tvSeriesList = try await searchService.searchTVSeries(query: query)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testSearchPeople() async throws {
        let query = "tom hardy"

        let personList = try await searchService.searchPeople(query: query)

        XCTAssertFalse(personList.results.isEmpty)
    }

}
