import Foundation
@testable import TMDb

extension PersonExternalLinksCollection {

    static func mock(
        id: Person.ID,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil,
        facebook: FacebookLink? = nil,
        instagram: InstagramLink? = nil,
        twitter: TwitterLink? = nil,
        tikTok: TikTokLink? = nil
    ) -> PersonExternalLinksCollection {
        PersonExternalLinksCollection(
            id: id,
            imdb: imdb,
            wikiData: wikiData,
            facebook: facebook,
            instagram: instagram,
            twitter: twitter,
            tikTok: tikTok
        )
    }

    static var sydneySweeney: PersonExternalLinksCollection {
        .mock(
            id: 346698,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )
    }

}
