@testable import TMDb
import XCTest

class GenreDTOTests: XCTestCase {

    func testDecodeReturnsGenre() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(GenreDTO.self, from: data)

        XCTAssertEqual(result, genre)
    }

    private let json = """
    {
        "id": 28,
        "name": "Action"
    }
    """

    private let genre = GenreDTO(
        id: 28,
        name: "Action"
    )

}
