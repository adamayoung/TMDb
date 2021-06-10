import Foundation

/// A TMDb error.
public enum TMDbError: Error {

    /// Network error.
    case network(Error)
    /// Unauthorised.
    case unauthorized
    /// Not found.
    case notFound
    /// Unknown error.
    case unknown
    /// Data decode error.
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
