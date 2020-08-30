import Foundation

enum ConfigurationEndpoint {

    static let basePath = URL(string: "/configuration")!

    case api

}

extension ConfigurationEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .api:
            return Self.basePath
        }
    }

}
