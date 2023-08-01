import Foundation

public enum TMDbError: Equatable, LocalizedError {

    /// An error indicating the resource could not be found.
    case notFound

    /// An error indicating there was a network problem.
    case network(Error)

    /// An unknown error.
    case unknown

    public static func == (lhs: TMDbError, rhs: TMDbError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound):
            return true

        case (.network, .network):
            return true

        case (.unknown, .unknown):
            return true

        default:
            return false
        }
    }

}

extension TMDbError {

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Not found"

        case .network:
            return "Network error"

        case .unknown:
            return "Unknown"
        }
    }

}
