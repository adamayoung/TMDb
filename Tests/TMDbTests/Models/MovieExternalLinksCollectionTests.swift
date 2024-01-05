@testable import TMDb
import XCTest

final class MovieExternalLinksCollectionTests: XCTestCase {

    func testDecodeReturnsMovieExternalLinksCollection() throws {
        let expectedResult = MovieExternalLinksCollection(
            id: 346698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieExternalLinksCollection.self,
            fromResource: "movie-external-ids"
        )

        XCTAssertEqual(result, expectedResult)
    }

    func testEncodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = MovieExternalLinksCollection(
            id: 346698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(MovieExternalLinksCollection.self, from: data)

        XCTAssertEqual(result, linksCollection)
    }

}
