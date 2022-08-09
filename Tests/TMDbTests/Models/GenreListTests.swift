@testable import TMDb
import XCTest

final class GenreListTests: XCTestCase {

    func testDecodeReturnsGenreList() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(GenreList.self, fromResource: "genres-list")

        XCTAssertEqual(result.genres, genreList.genres)
    }

    private let genreList = GenreList(
        genres: [
            .init(id: 28, name: "Action")
        ]
    )

}
