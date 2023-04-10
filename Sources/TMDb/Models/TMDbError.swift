import Foundation

/// A TMDb error.
public enum TMDbError: Error {

    /// Network error.
    case network(Error)
    /// Bad request.
    case badRequest(String?)
    /// Unauthorised.
    case unauthorised(String?)
    /// Forbidden.
    case forbidden(String?)
    /// Not found.
    case notFound(String?)
    /// Method not allowed.
    case methodNotAllowed(String?)
    /// Not acceptable.
    case notAcceptable(String?)
    /// Unprocessable content.
    case unprocessableContent(String?)
    /// Too many requests.
    case tooManyRequests(String?)
    /// Internal server error.
    case internalServerError(String?)
    /// Not implemented.
    case notImplemented(String?)
    /// Bad gateway.
    case badGateway(String?)
    /// Service unavailable.
    case serviceUnavailable(String?)
    /// Gateway timeout.
    case gatewayTimeout(String?)
    /// Data decode error.
    case decode(Error)
    /// Unknown error.
    case unknown

}

extension TMDbError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription

        case .badRequest:
            return NSLocalizedString("BAD_REQUEST", bundle: .module, comment: "Bad request")

        case .unauthorised:
            return NSLocalizedString("UNAUTHORISED", bundle: .module, comment: "Unauthorised")

        case .forbidden:
            return NSLocalizedString("FORBIDDEN", bundle: .module, comment: "Forbidden")

        case .notFound:
            return NSLocalizedString("NOT_FOUND", bundle: .module, comment: "Not found")

        case .methodNotAllowed:
            return NSLocalizedString("METHOD_NOT_ALLOWED", bundle: .module, comment: "Method not allowed")

        case .notAcceptable:
            return NSLocalizedString("NOT_ACCEPTABLE", bundle: .module, comment: "Not acceptable")

        case .unprocessableContent:
            return NSLocalizedString("UNPROCESSABLE_CONTENT", bundle: .module, comment: "Unprocessable content")

        case .tooManyRequests:
            return NSLocalizedString("TOO_MANY_REQUESTS", bundle: .module, comment: "Too many requests")

        case .internalServerError:
            return NSLocalizedString("INTERNAL_SERVER_ERROR", bundle: .module, comment: "Internal server error")

        case .notImplemented:
            return NSLocalizedString("NOT_IMPLEMENTED", bundle: .module, comment: "Not implemented")

        case .badGateway:
            return NSLocalizedString("BAD_GATEWAY", bundle: .module, comment: "Bad gateway")

        case .serviceUnavailable:
            return NSLocalizedString("SERVICE_UNAVAILABLE", bundle: .module, comment: "Service unavailable")

        case .gatewayTimeout:
            return NSLocalizedString("GATEWAY_TIMEOUT", bundle: .module, comment: "Gatewat timeout")

        case .decode(let error):
            return error.localizedDescription

        case .unknown:
            return NSLocalizedString("UNKNOWN_ERROR", bundle: .module, comment: "Unknown error")
        }
    }

    public var failureReason: String? {
        switch self {
        case .network(let error):
            return (error as NSError).localizedFailureReason

        case .badRequest(let statusMessage):
            return statusMessage

        case .unauthorised(let statusMessage):
            return statusMessage

        case .forbidden(let statusMessage):
            return statusMessage

        case .notFound(let statusMessage):
            return statusMessage

        case .methodNotAllowed(let statusMessage):
            return statusMessage

        case .notAcceptable(let statusMessage):
            return statusMessage

        case .unprocessableContent(let statusMessage):
            return statusMessage

        case .tooManyRequests(let statusMessage):
            return statusMessage

        case .internalServerError(let statusMessage):
            return statusMessage

        case .notImplemented(let statusMessage):
            return statusMessage

        case .badGateway(let statusMessage):
            return statusMessage

        case .serviceUnavailable(let statusMessage):
            return statusMessage

        case .gatewayTimeout(let statusMessage):
            return statusMessage

        case .decode(let error):
            return (error as NSError).localizedFailureReason

        case .unknown:
            return nil
        }
    }

}
