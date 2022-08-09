import Foundation

enum GenresEndpoint {

    case movies

}

extension GenresEndpoint: Endpoint {

    private static let basePath = URL(string: "/genre")!

    var path: URL {
        switch self {
        case .movies:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")
        }
    }

}
