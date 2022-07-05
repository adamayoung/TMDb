import Foundation

enum ConfigurationEndpoint {

    case api
    case countries
    case jobs

}

extension ConfigurationEndpoint: Endpoint {

    private static let basePath = URL(string: "/configuration")!

    var path: URL {
        switch self {
        case .api:
            return Self.basePath

        case .countries:
            return Self.basePath
                .appendingPathComponent("countries")

        case .jobs:
            return Self.basePath
                .appendingPathComponent("jobs")
        }
    }

}
