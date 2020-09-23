@testable import TMDb
import XCTest

class MediaPageableListDTOTests: XCTestCase {

    func testDecodeReturnsMediaPageableList() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(MediaPageableListDTO.self, from: data)

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let json = """
    {
        "page": 1,
        "results": [
            {
                "id": 1,
                "title": "Fight Club",
                "media_type": "movie"
            },
            {
                "id": 2,
                "name": "The Mrs Bradley Mysteries",
                "media_type": "tv"
            },
            {
                "id": 51329,
                "name": "Bradley Cooper",
                "media_type": "person"
            }
        ],
        "total_results": 3,
        "total_pages": 1
    }
    """

    private let list = MediaPageableListDTO(
        page: 1,
        results: [
            .movie(MovieDTO(id: 1, title: "Fight Club")),
            .tvShow(TVShowDTO(id: 2, name: "The Mrs Bradley Mysteries")),
            .person(PersonDTO(id: 51329, name: "Bradley Cooper"))
        ],
        totalResults: 3,
        totalPages: 1
    )

}
