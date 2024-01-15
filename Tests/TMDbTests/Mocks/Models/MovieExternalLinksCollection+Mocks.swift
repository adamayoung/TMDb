import Foundation
@testable import TMDb

extension MovieExternalLinksCollection {

    static func mock(
        id: Movie.ID,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil,
        facebook: FacebookLink? = nil,
        instagram: InstagramLink? = nil,
        twitter: TwitterLink? = nil
    ) -> MovieExternalLinksCollection {
        MovieExternalLinksCollection(
            id: id,
            imdb: imdb,
            wikiData: wikiData,
            facebook: facebook,
            instagram: instagram,
            twitter: twitter
        )
    }

    static var barbie: MovieExternalLinksCollection {
        .mock(
            id: 346698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )
    }

}
