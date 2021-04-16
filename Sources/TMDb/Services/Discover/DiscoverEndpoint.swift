import Foundation

enum DiscoverEndpoint {

    static let basePath = URL(string: "/discover")!

    case movies(sortBy: MovieSortBy? = nil, people: [Person.ID]? = nil, page: Int? = nil)
    case tvShows(sortBy: TVShowSortBy? = nil, page: Int? = nil)

}

extension DiscoverEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .movies(let sortBy, let people, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingSortBy(sortBy)
                .appendingWithPeople(people)
                .appendingPage(page)

        case .tvShows(let sortBy, let page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingSortBy(sortBy)
                .appendingPage(page)
        }
    }

}
