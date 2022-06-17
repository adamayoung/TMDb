@testable import TMDb
import XCTest

final class ImageCollectionTests: XCTestCase {

    func testDecodeReturnsImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(ImageCollection.self, fromResource: "image-collection")

        XCTAssertEqual(result.id, imageCollection.id)
        XCTAssertEqual(result.backdrops, imageCollection.backdrops)
        XCTAssertEqual(result.logos, imageCollection.logos)
        XCTAssertEqual(result.posters, imageCollection.posters)
    }

    private let imageCollection = ImageCollection(
        id: 550,
        posters: [
            ImageMetadata(filePath: URL(string: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg")!, width: 1200, height: 1800,
                          aspectRatio: 0.666666666666667, languageCode: "en")
        ],
        logos: [
            ImageMetadata(filePath: URL(string: "/fasasakfRaCRCTh8GqN30f8oyQF.jpg")!, width: 100, height: 400,
                          aspectRatio: 2.5, languageCode: nil)
        ],
        backdrops: [
            ImageMetadata(filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!, width: 1280, height: 720,
                          aspectRatio: 1.77777777777778, languageCode: nil)
        ])

}
