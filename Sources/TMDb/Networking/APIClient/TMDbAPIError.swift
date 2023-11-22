import Foundation

///
/// A model representing a TMDb API error.
///
public enum TMDbAPIError: Error {

    ///
    /// Network error.
    ///
    case network(Error)

    ///
    /// Bad request.
    ///
    case badRequest(String?)

    ///
    /// Unauthorised.
    ///
    case unauthorised(String?)

    ///
    /// Forbidden.
    ///
    case forbidden(String?)

    ///
    /// Not found.
    ///
    case notFound(String?)

    ///
    /// Method not allowed.
    ///
    case methodNotAllowed(String?)

    ///
    /// Not acceptable.
    ///
    case notAcceptable(String?)

    ///
    /// Unprocessable content.
    ///
    case unprocessableContent(String?)

    ///
    /// Too many requests.
    ///
    case tooManyRequests(String?)

    ///
    /// Internal server error.
    ///
    case internalServerError(String?)

    ///
    /// Not implemented.
    ///
    case notImplemented(String?)

    ///
    /// Bad gateway.
    ///
    case badGateway(String?)

    ///
    /// Service unavailable.
    ///
    case serviceUnavailable(String?)

    ///
    /// Gateway timeout.
    ///
    case gatewayTimeout(String?)

    ///
    /// Data decode error.
    ///
    case decode(Error)

    ///
    /// Unknown error.
    ///
    case unknown

}
