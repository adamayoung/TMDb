import Foundation

enum SearchEndpoint {

    case multi(query: String, page: Int? = nil)
    case movies(query: String, year: Int? = nil, page: Int? = nil)
    case tvSeries(query: String, firstAirDateYear: Int? = nil, page: Int? = nil)
    case people(query: String, page: Int? = nil)

}

extension SearchEndpoint: Endpoint {

    static let basePath = URL(string: "/search")!

    private enum QueryItemName {
        static let query = "query"
    }

    var path: URL {
        switch self {

        case .multi(let query, let page):
            return Self.basePath
                .appendingPathComponent("multi")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingPage(page)

        case .movies(let query, let year, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingYear(year)
                .appendingPage(page)

        case .tvSeries(let query, let firstAirDateYear, let page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingFirstAirDateYear(firstAirDateYear)
                .appendingPage(page)

        case .people(let query, let page):
            return Self.basePath
                .appendingPathComponent("person")
                .appendingQueryItem(name: QueryItemName.query, value: query)
                .appendingPage(page)
        }
    }

}
