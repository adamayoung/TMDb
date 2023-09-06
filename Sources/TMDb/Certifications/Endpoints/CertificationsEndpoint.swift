import Foundation

enum CertificationsEndpoint {

    case movie
    case tvSeries

}

extension CertificationsEndpoint: Endpoint {

    private static let basePath = URL(string: "/certification")!

    var path: URL {
        switch self {
        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")

        case .tvSeries:
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent("list")
        }
    }

}
