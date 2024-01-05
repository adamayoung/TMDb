@testable import TMDb
import XCTest

final class TVSeriesExternalLinksCollectionTests: XCTestCase {

    func testDecodeReturnsMovieExternalLinksCollection() throws {
        let expectedResult = TVSeriesExternalLinksCollection(
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesExternalLinksCollection.self,
            fromResource: "tv-series-external-ids"
        )

        XCTAssertEqual(result, expectedResult)
    }

    func testEncodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = TVSeriesExternalLinksCollection(
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(TVSeriesExternalLinksCollection.self, from: data)

        XCTAssertEqual(result, linksCollection)
    }

}
