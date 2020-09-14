@testable import TMDb
import XCTest

class MediaTests: XCTestCase {

    func testID_whenMovie_returnsID() {
        XCTAssertEqual(medias[0].id, 1)
    }

    func testID_whenTVShow_returnsID() {
        XCTAssertEqual(medias[1].id, 2)
    }

    func testID_whenPerson_returnsID() {
        XCTAssertEqual(medias[2].id, 51329)
    }

    func testDecode_returnsMedias() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode([Media].self, from: data)

        XCTAssertEqual(result, medias)
    }

    private let json = """
    [
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
    ]
    """

    private let medias: [Media] = [
        .movie(Movie(id: 1, title: "Fight Club")),
        .tvShow(TVShow(id: 2, name: "The Mrs Bradley Mysteries")),
        .person(Person(id: 51329, name: "Bradley Cooper"))
    ]

}
