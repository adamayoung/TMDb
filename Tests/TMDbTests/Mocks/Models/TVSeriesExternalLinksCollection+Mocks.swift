import Foundation
@testable import TMDb

extension TVSeriesExternalLinksCollection {

    static func mock(
        id: TVSeries.ID,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil,
        facebook: FacebookLink? = nil,
        instagram: InstagramLink? = nil,
        twitter: TwitterLink? = nil
    ) -> TVSeriesExternalLinksCollection {
        TVSeriesExternalLinksCollection(
            id: id,
            imdb: imdb,
            wikiData: wikiData,
            facebook: facebook,
            instagram: instagram,
            twitter: twitter
        )
    }

    static var lockeAndKey: TVSeriesExternalLinksCollection {
        .mock(
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )
    }

}
