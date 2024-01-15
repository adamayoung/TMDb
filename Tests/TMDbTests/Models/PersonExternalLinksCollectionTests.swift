@testable import TMDb
import XCTest

final class PersonExternalLinksCollectionTests: XCTestCase {

    func testDecodeReturnsPersonExternalLinksCollection() throws {
        let expectedResult = PersonExternalLinksCollection(
            id: 115440,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonExternalLinksCollection.self,
            fromResource: "person-external-ids"
        )

        XCTAssertEqual(result, expectedResult)
    }

    func testEncodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = PersonExternalLinksCollection(
            id: 115440,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(PersonExternalLinksCollection.self, from: data)

        XCTAssertEqual(result, linksCollection)
    }

}
