@testable import TMDb
import XCTest

final class VideoMetadataTests: XCTestCase {

    func testDecodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(VideoMetadata.self, fromResource: "video-metadata")

        XCTAssertEqual(result.id, videoMetadata.id)
        XCTAssertEqual(result.name, videoMetadata.name)
        XCTAssertEqual(result.site, videoMetadata.site)
        XCTAssertEqual(result.key, videoMetadata.key)
        XCTAssertEqual(result.type, videoMetadata.type)
        XCTAssertEqual(result.size, videoMetadata.size)
    }

    private let videoMetadata = VideoMetadata(
        id: "533ec654c3a36854480003eb",
        name: "Trailer 1",
        site: "YouTube",
        key: "SUXWAEX2jlg",
        type: .trailer,
        size: .s720
    )

}
