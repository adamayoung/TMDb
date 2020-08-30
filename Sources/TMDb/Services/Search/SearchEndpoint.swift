import Foundation

enum SearchEndpoint {

    static let basePath = URL(string: "/search")!

    case all(query: String, page: Int?)
    case movies(query: String, year: Int?, page: Int?)
    case tvShows(query: String, firstAirDateYear: Int?, page: Int?)
    case people(query: String, page: Int?)

}

extension SearchEndpoint: Endpoint {

    var url: URL {
        switch self {

        case .all(let query, let page):
            return Self.basePath
                .appendingPathComponent("multi")
                .appendingQueryItem(name: "query", value: query)
                .appendingPage(page)

        case .movies(let query, let year, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingQueryItem(name: "query", value: query)
                .appendingYear(year)
                .appendingPage(page)

        case .tvShows(let query, let firstAirDateYear, let page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingQueryItem(name: "query", value: query)
                .appendingFirstAirDateYear(firstAirDateYear)
                .appendingPage(page)

        case .people(let query, let page):
            return Self.basePath
                .appendingPathComponent("person")
                .appendingQueryItem(name: "query", value: query)
                .appendingPage(page)
        }
    }

}
