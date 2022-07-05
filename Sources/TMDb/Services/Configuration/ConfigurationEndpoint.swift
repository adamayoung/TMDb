import Foundation

enum ConfigurationEndpoint {

    static let basePath = URL(string: "/configuration")!

    case api
    case countries

}

extension ConfigurationEndpoint: Endpoint {

    var path: URL {
        switch self {
        case .api:
            return Self.basePath

        case .countries:
            return Self.basePath
                .appendingPathComponent("countries")
        }
    }

}
