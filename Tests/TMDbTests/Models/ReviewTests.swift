@testable import TMDb
import XCTest

class ReviewTests: XCTestCase {

    func testDecodeReturnsReview() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Review.self, from: data)

        XCTAssertEqual(result, review)
    }

    // swiftlint:disable line_length
    private let json = """
    {
        "id": "5488c29bc3a3686f4a00004a",
        "author": "Travis Bell",
        "content": "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!",
        "iso_639_1": "en",
        "media_id": 118340,
        "media_title": "Guardians of the Galaxy",
        "media_type": "Movie",
        "url": "https://www.themoviedb.org/review/5488c29bc3a3686f4a00004a"
    }
    """

    private let review = Review(
        id: "5488c29bc3a3686f4a00004a",
        author: "Travis Bell",
        content: "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!"
    )
    // swiftlint:enable line_length

}
