//
//  ToolErrorMapper.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Maps a ``TMDbError`` to a short, model-readable message for recoverable cases.
///
/// Language model tools favour recovery over failure: returning a readable string
/// lets the model adjust (try a different id, broaden the query, ask the user)
/// rather than aborting the turn. Genuine infrastructure failures return `nil` so
/// the caller rethrows them and the host app sees the real error.
///
/// This type references only the public ``TMDbError`` and so compiles on every
/// supported platform.
///
enum ToolErrorMapper {

    ///
    /// Returns a readable message for a recoverable error, or `nil` to rethrow.
    ///
    /// - Parameters:
    ///   - error: The error thrown by a TMDb service.
    ///   - entity: A noun for the looked-up resource, such as `"movie"`.
    ///   - id: The identifier that was looked up, when applicable.
    ///
    /// - Returns: A message to return to the model, or `nil` when the error should
    ///   propagate to the host app.
    ///
    static func message(for error: TMDbError, entity: String? = nil, id: Int? = nil) -> String? {
        switch error {
        case .notFound:
            let suffix = id.map { " with id \($0)" } ?? ""
            return "No TMDb \(entity ?? "result")\(suffix) found."

        case .badRequest(let message):
            return "Invalid request: \(message ?? "bad request"). Check the id or country code."

        case .tooManyRequests:
            return "TMDb is rate limiting requests right now; please retry shortly."

        case .unauthorised, .forbidden:
            return "TMDb access was denied (check the API key)."

        case .network, .serverError, .decode, .invalidRating, .unknown:
            // Infrastructure or programmer errors the model cannot recover from by
            // re-prompting — rethrow so the host app handles them.
            return nil
        }
    }

}
