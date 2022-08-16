@testable import TMDb
import XCTest

final class WatchProviderTests: XCTestCase {

    func testDecodeReturnsWatchProvider() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(WatchProvider.self, fromResource: "watch-provider")

        XCTAssertEqual(result, watchProvider)
    }

    private let watchProvider = WatchProvider(
        id: 8,
        name: "Netflix",
        logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
    )

}
