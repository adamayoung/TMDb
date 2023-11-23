@testable import TMDb
import XCTest

final class TVEpisodeImageCollectionTests: XCTestCase {

    func testDecodeReturnsImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeImageCollection.self,
            fromResource: "tv-episode-image-collection"
        )

        XCTAssertEqual(result.id, episodeImageCollection.id)
        XCTAssertEqual(result.stills, episodeImageCollection.stills)
    }

    private let episodeImageCollection = TVEpisodeImageCollection(
        id: 66633,
        stills: [
            ImageMetadata(filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!, width: 1920, height: 1080,
                          aspectRatio: 1.77778, voteAverage: 5.3125, voteCount: 1, languageCode: nil)
        ]
    )

}
