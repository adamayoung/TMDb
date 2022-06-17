import Foundation

enum TrendingEndpoint {

    static let basePath = URL(string: "/trending")!

    case movies(timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil)
    case tvShows(timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil)
    case people(timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil)

}

extension TrendingEndpoint: Endpoint {

    var path: URL {
        switch self {
        case .movies(let timeWindow, let page):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case .tvShows(let timeWindow, let page):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)

        case .people(let timeWindow, let page):
            return Self.basePath
                .appendingPathComponent("person")
                .appendingPathComponent(timeWindow)
                .appendingPage(page)
        }
    }

}
