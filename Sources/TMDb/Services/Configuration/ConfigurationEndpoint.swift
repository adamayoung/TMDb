import Foundation

enum ConfigurationEndpoint {

    static let basePath = URL(string: "/configuration")!

    case api

}

extension ConfigurationEndpoint: Endpoint {

    var path: URL {
        switch self {
        case .api:
            return Self.basePath
        }
    }

}
