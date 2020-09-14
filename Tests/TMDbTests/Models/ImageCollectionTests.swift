@testable import TMDb
import XCTest

class ImageCollectionTests: XCTestCase {

    func testDecodeReturnsImageCollection() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ImageCollection.self, from: data)

        XCTAssertEqual(result.id, imageCollection.id)
        XCTAssertEqual(result.backdrops, imageCollection.backdrops)
        XCTAssertEqual(result.posters, imageCollection.posters)
    }

    private let json = """
    {
        "id": 550,
        "backdrops": [
            {
              "aspect_ratio": 1.77777777777778,
              "file_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
              "height": 720,
              "iso_639_1": null,
              "vote_average": 0,
              "vote_count": 0,
              "width": 1280
            }
        ],
        "posters": [
            {
              "aspect_ratio": 0.666666666666667,
              "file_path": "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
              "height": 1800,
              "iso_639_1": "en",
              "vote_average": 0,
              "vote_count": 0,
              "width": 1200
            }
        ]
    }
    """

    private let imageCollection = ImageCollection(
        id: 550,
        posters: [
            ImageMetadata(filePath: URL(string: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg")!, width: 1200, height: 1800)
        ],
        backdrops: [
            ImageMetadata(filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!, width: 1280, height: 720)
        ])

}
