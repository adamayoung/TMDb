import Foundation

enum CertificationsEndpoint {

    case movie
    case tvShow

}

extension CertificationsEndpoint: Endpoint {

    private static let basePath = URL(string: "/certification")!

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
