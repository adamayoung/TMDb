@testable import TMDb
import XCTest

final class PersonImageCollectionTests: XCTestCase {

    func testDecodeReturnsPersonImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonImageCollection.self, fromResource: "person-image-collection")

        XCTAssertEqual(result.id, personImageCollection.id)
        XCTAssertEqual(result.profiles, personImageCollection.profiles)
    }

    private let personImageCollection = PersonImageCollection(
        id: 66633,
        profiles: [
            ImageMetadata(
                filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!,
                width: 546,
                height: 819,
                aspectRatio: 0.666666666666667,
                voteAverage: 7.21,
                voteCount: 345
            ),
            ImageMetadata(
                filePath: URL(string: "/lYqC8Amj4owX05xQg5Yo7uUHgah.jpg")!,
                width: 2000,
                height: 3000,
                aspectRatio: 0.666666666666667,
                voteAverage: 4.21,
                voteCount: 3
            )
        ]
    )

}
