@testable import TMDb
import XCTest

final class MediaTests: XCTestCase {

    func testIDWhenMovieReturnsID() {
        XCTAssertEqual(medias[0].id, 1)
    }

    func testIDWhenTVSeriesReturnsID() {
        XCTAssertEqual(medias[1].id, 2)
    }

    func testIDWhenPersonReturnsID() {
        XCTAssertEqual(medias[2].id, 51329)
    }

    func testDecodeReturnsMedias() throws {
        let result = try JSONDecoder.theMovieDatabase.decode([Media].self, fromResource: "media")

        XCTAssertEqual(result, medias)
    }

    private let medias: [Media] = [
        .movie(Movie(id: 1, title: "Fight Club")),
        .tvSeries(TVSeries(id: 2, name: "The Mrs Bradley Mysteries")),
        .person(Person(id: 51329, name: "Bradley Cooper", gender: .unknown))
    ]

}
