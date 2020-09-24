import Foundation

enum PeopleEndpoint {

    static let basePath = URL(string: "/person")!

    case details(personID: PersonDTO.ID)
    case combinedCredits(personID: PersonDTO.ID)
    case movieCredits(personID: PersonDTO.ID)
    case tvShowCredits(personID: PersonDTO.ID)
    case images(personID: PersonDTO.ID)
    case popular(page: Int? = nil)

}

extension PeopleEndpoint: Endpoint {

    var url: URL {
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

        case .tvShowCredits(let personID):
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

        }
    }

}
