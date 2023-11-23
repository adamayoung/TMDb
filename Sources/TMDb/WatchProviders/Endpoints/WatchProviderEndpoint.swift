import Foundation

enum WatchProviderEndpoint {

    case regions
    case movie(regionCode: String?)
    case tvSeries(regionCode: String?)

}

extension WatchProviderEndpoint: Endpoint {

    private static let basePath = URL(string: "/watch/providers")!

    var path: URL {
        switch self {
        case .regions:
            return Self.basePath
                .appendingPathComponent("regions")

        case .movie(let regionCode):
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingWatchRegion(regionCode)

        case .tvSeries(let regionCode):
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingWatchRegion(regionCode)
        }
    }

}

private extension URL {

    private enum QueryItemName {
        static let watchRegion = "watch_region"
    }

    func appendingWatchRegion(_ regionCode: String?) -> URL {
        guard let regionCode else {
            return self
        }

        return self.appendingQueryItem(name: QueryItemName.watchRegion, value: regionCode)
    }

}
