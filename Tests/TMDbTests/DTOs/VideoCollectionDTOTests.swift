@testable import TMDb
import XCTest

class VideoCollectionDTOTests: XCTestCase {

    func testDecodeReturnsVideoCollection() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(VideoCollectionDTO.self, from: data)

        XCTAssertEqual(result, videoCollection)
    }

    private let json = """
    {
        "id": 550,
        "results": [
            {
                "id": "533ec654c3a36854480003eb",
                "iso_639_1": "en",
                "iso_3166_1": "US",
                "key": "SUXWAEX2jlg",
                "name": "Trailer 1",
                "site": "YouTube",
                "size": 720,
                "type": "Trailer"
            }
        ]
    }
    """

    private let videoCollection = VideoCollectionDTO(
        id: 550,
        results: [
            VideoMetadataDTO(
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
