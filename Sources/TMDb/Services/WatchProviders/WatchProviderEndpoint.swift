import Foundation

enum WatchProviderEndpoint {

    case regions

}

extension WatchProviderEndpoint: Endpoint {

    private static let basePath = URL(string: "/watch/providers")!

    var path: URL {
        switch self {
        case .regions:
            return Self.basePath
                .appendingPathComponent("regions")
        }
    }

}
