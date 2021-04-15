import Foundation

enum DiscoverEndpoint {

    static let basePath = URL(string: "/discover")!

    case movies(sortBy: MovieSortBy? = nil, withPeople: [Person.ID]? = nil, page: Int? = nil)
    case tvShows(sortBy: TVShowSortBy? = nil, page: Int? = nil)

}

extension DiscoverEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .movies(let sortBy, let withPeople, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingSortBy(sortBy)
                .appendingWithPeople(withPeople)
                .appendingPage(page)

        case .tvShows(let sortBy, let page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingSortBy(sortBy)
                .appendingPage(page)
        }
    }

}
