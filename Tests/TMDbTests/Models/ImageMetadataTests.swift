@testable import TMDb
import XCTest

final class ImageMetadataTests: XCTestCase {

    func testIDReturnsFilePath() {
        XCTAssertEqual(imageMetadata.id, imageMetadata.filePath)
    }

    func testDecodeReturnsImageMetadata() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(ImageMetadata.self, fromResource: "image-metadata")

        XCTAssertEqual(result.filePath, imageMetadata.filePath)
        XCTAssertEqual(result.width, imageMetadata.width)
        XCTAssertEqual(result.height, imageMetadata.height)
        XCTAssertEqual(result.aspectRatio, imageMetadata.aspectRatio)
        XCTAssertEqual(result.languageCode, imageMetadata.languageCode)
    }

    private let imageMetadata = ImageMetadata(
        filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!,
        width: 1280,
        height: 720,
        aspectRatio: 1.77777777777778,
        languageCode: "en"
    )

}
