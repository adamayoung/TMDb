@testable import TMDb
import XCTest

class GenreTests: XCTestCase {

    func testDecodeReturnsGenre() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Genre.self, from: data)

        XCTAssertEqual(result, genre)
    }

    private let json = """
    {
        "id": 28,
        "name": "Action"
    }
    """

    private let genre = Genre(
        id: 28,
        name: "Action"
    )

}
