import TMDb
import XCTest

final class SearchIntegrationTests: XCTestCase {

    var searchService: SearchService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
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

    func testSearchTVShows() async throws {
        let query = "game of thrones"

        let tvShowList = try await searchService.searchTVShows(query: query)

        XCTAssertFalse(tvShowList.results.isEmpty)
    }

    func testSearchPeople() async throws {
        let query = "tom hardy"

        let personList = try await searchService.searchPeople(query: query)

        XCTAssertFalse(personList.results.isEmpty)
    }

}
