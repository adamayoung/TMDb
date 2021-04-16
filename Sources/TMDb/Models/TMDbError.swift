import Foundation

public enum TMDbError: Error {

    case network(Error)
    case unauthorized
    case notFound
    case unknown
    case decode(Error)

}

extension TMDbError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription

        case .unauthorized:
            return "Unauthorised"

        case .notFound:
            return "Not Found"

        case .unknown:
            return "Unknown Error"

        case .decode:
            return "Data Decode Error"
        }
    }

}
