import Foundation

enum CertificationsEndpoint {

    static let basePath = URL(string: "/certification")!

    case movie
    case tvShow

}

extension CertificationsEndpoint: Endpoint {

    var url: URL {
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
