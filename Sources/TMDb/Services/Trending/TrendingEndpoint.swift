import Foundation

enum TrendingEndpoint {

    static let basePath = URL(string: "/trending")!

    case movies(timeWindow: TrendingTimeWindowFilterType, page: Int?)
    case tvShows(timeWindow: TrendingTimeWindowFilterType, page: Int?)
    case people(timeWindow: TrendingTimeWindowFilterType, page: Int?)

}

extension TrendingEndpoint: Endpoint {

    var url: URL {
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
