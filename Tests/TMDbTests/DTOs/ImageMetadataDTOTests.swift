@testable import TMDb
import XCTest

class ImageMetadataDTOTests: XCTestCase {

    func testIDReturnsFilePath() {
        XCTAssertEqual(imageMetadata.id, imageMetadata.filePath)
    }

    func testDecodeReturnsImageMetadata() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ImageMetadataDTO.self, from: data)

        XCTAssertEqual(result, imageMetadata)
    }

    private let json = """
    {
        "aspect_ratio": 1.77777777777778,
        "file_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
        "height": 720,
        "iso_639_1": null,
        "vote_average": 0,
        "vote_count": 0,
        "width": 1280
    }
    """

    private let imageMetadata = ImageMetadataDTO(
        filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!,
        width: 1280,
        height: 720
    )

}
