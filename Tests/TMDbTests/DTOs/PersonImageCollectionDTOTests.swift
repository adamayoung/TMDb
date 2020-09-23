@testable import TMDb
import XCTest

class PersonImageCollectionDTOTests: XCTestCase {

    func testDecodeReturnsPersonImageCollection() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(PersonImageCollectionDTO.self, from: data)

        XCTAssertEqual(result.id, personImageCollection.id)
        XCTAssertEqual(result.profiles, personImageCollection.profiles)
    }

    private let json = """
    {
        "id": 66633,
        "profiles": [
            {
              "aspect_ratio": 0.666666666666667,
              "file_path": "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg",
              "height": 819,
              "iso_639_1": null,
              "vote_average": 5.3125,
              "vote_count": 1,
              "width": 546
            },
            {
              "aspect_ratio": 0.666666666666667,
              "file_path": "/lYqC8Amj4owX05xQg5Yo7uUHgah.jpg",
              "height": 3000,
              "iso_639_1": null,
              "vote_average": 0,
              "vote_count": 0,
              "width": 2000
            }
        ]
    }
    """

    private let personImageCollection = PersonImageCollectionDTO(
        id: 66633,
        profiles: [
            ImageMetadataDTO(
                filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!,
                width: 546,
                height: 819
            ),
            ImageMetadataDTO(
                filePath: URL(string: "/lYqC8Amj4owX05xQg5Yo7uUHgah.jpg")!,
                width: 2000,
                height: 3000
            )
        ]
    )

}
