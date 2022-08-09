import Foundation

enum GenresEndpoint {

    case movie
    case tvShow

}

extension GenresEndpoint: Endpoint {

    private static let basePath = URL(string: "/genre")!

    var path: URL {
        switch self {
        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")

        case .tvShow:
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent("list")
        }
    }

}
