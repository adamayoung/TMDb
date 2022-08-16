import Foundation

enum WatchProviderEndpoint {

    case regions
    case movie

}

extension WatchProviderEndpoint: Endpoint {

    private static let basePath = URL(string: "/watch/providers")!

    var path: URL {
        switch self {
        case .regions:
            return Self.basePath
                .appendingPathComponent("regions")

        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingWatchRegion()
        }
    }

}

private extension URL {

    private enum QueryItemName {
        static let watchRegion = "watch_region"
    }

    func appendingWatchRegion() -> URL {
        guard let regionCode = Locale.current.regionCode else {
            return self
        }

        return self.appendingQueryItem(name: QueryItemName.watchRegion, value: regionCode)
    }

}
