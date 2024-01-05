import Foundation

enum PeopleEndpoint {

    case details(personID: Person.ID)
    case combinedCredits(personID: Person.ID)
    case movieCredits(personID: Person.ID)
    case tvSeriesCredits(personID: Person.ID)
    case images(personID: Person.ID)
    case popular(page: Int? = nil)
    case externalIDs(personID: Person.ID)

}

extension PeopleEndpoint: Endpoint {

    private static let basePath = URL(string: "/person")!

    var path: URL {
        switch self {
        case .details(let personID):
            return Self.basePath
                .appendingPathComponent(personID)

        case .combinedCredits(let personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("combined_credits")

        case .movieCredits(let personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("movie_credits")

        case .tvSeriesCredits(let personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("tv_credits")

        case .images(let personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("images")

        case .popular(let page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)

        case .externalIDs(let personID):
            return Self.basePath
                .appendingPathComponent(personID)
                .appendingPathComponent("external_ids")
        }
    }

}
