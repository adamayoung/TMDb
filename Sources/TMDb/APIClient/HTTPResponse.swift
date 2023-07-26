import Foundation

///
/// A model representing an HTTP response.
///
public struct HTTPResponse {

    ///
    /// The HTTP status code of the response.
    ///
    public let statusCode: Int

    ///
    /// Data returned in the response body.
    ///
    public let data: Data?

    ///
    /// Creates an HTTP response object.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response.
    ///   - data: Data returned in the response body.
    ///
    public init(statusCode: Int = 200, data: Data? = nil) {
        self.statusCode = statusCode
        self.data = data
    }

}
