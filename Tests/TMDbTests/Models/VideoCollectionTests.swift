@testable import TMDb
import XCTest

final class VideoCollectionTests: XCTestCase {

    func testDecodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(VideoCollection.self, fromResource: "video-collection")

        XCTAssertEqual(result.id, videoCollection.id)
        XCTAssertEqual(result.results, videoCollection.results)
    }

    private let videoCollection = VideoCollection(
        id: 550,
        results: [
            VideoMetadata(
                id: "533ec654c3a36854480003eb",
                name: "Trailer 1",
                site: "YouTube",
                key: "SUXWAEX2jlg",
                type: .trailer,
                size: .s720
            )
        ]
    )

}
