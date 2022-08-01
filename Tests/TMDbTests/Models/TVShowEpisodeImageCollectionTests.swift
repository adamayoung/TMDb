@testable import TMDb
import XCTest

final class TVShowEpisodeImageCollectionTests: XCTestCase {

    func testDecodeReturnsImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TVShowEpisodeImageCollection.self, fromResource: "tv-show-episode-image-collection.json")

        XCTAssertEqual(result.id, episodeImageCollection.id)
        XCTAssertEqual(result.stills, episodeImageCollection.stills)
    }

    private let episodeImageCollection = TVShowEpisodeImageCollection(
        id: 66633,
        stills: [
            ImageMetadata(filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!, width: 1920, height: 1080,
                          aspectRatio: 1.77778, voteAverage: 5.3125, voteCount: 1, languageCode: nil)
        ]
    )

}