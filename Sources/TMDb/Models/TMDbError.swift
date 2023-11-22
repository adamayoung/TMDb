import Foundation

public enum TMDbError: Equatable, LocalizedError {

    /// An error indicating the resource could not be found.
    case notFound

    /// An error indicating there was a network problem.
    case network(Error)

    /// An unknown error.
    case unknown
    
    case apiError(TMDbAPIError)

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
                
            case .apiError(let error):
                switch error {
                    case .network(let error):
                        return error.localizedDescription
                    case .badRequest(let string):
                        return string
                    case .unauthorised(let string):
                        return string
                    case .forbidden(let string):
                        return string

                    case .notFound(let string):
                        return string

                    case .methodNotAllowed(let string):
                        return string

                    case .notAcceptable(let string):
                        return string

                    case .unprocessableContent(let string):
                        return string

                    case .tooManyRequests(let string):
                        return string

                    case .internalServerError(let string):
                        return string

                    case .notImplemented(let string):
                        return string

                    case .badGateway(let string):
                        return string

                    case .serviceUnavailable(let string):
                        return string

                    case .gatewayTimeout(let string):
                        return string

                    case .decode(let error):
                        return error.localizedDescription
                    case .unknown:
                        return "Really unknown"
                }
                
        }
    }

}
