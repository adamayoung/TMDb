//
//  TMDbStatusCode.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb API status code.
///
/// TMDb returns a numeric `status_code` in the body of most responses, distinct
/// from the HTTP status code. Each value identifies a specific outcome — see the
/// [TMDb status code reference](https://developer.themoviedb.org/docs/errors).
/// The HTTP status TMDb documents for each code is noted in that case's
/// documentation; the authoritative HTTP status for a given failure is carried
/// separately by ``TMDbErrorContext/httpStatusCode``.
///
/// A code not modelled by this library decodes to ``unknown(_:)``, preserving the
/// raw value, so a newly-introduced TMDb code never fails to represent.
///
/// - Note: Two status codes are equal when their ``rawValue``s are equal.
///   ``unknown(_:)`` only ever carries an undocumented code, so it never collides
///   with a named case in practice.
///
public enum TMDbStatusCode: RawRepresentable, Equatable, Hashable, Sendable {

    ///
    /// Success. (HTTP 200)
    ///
    case success

    ///
    /// Invalid service: this service does not exist. (HTTP 501)
    ///
    case invalidService

    ///
    /// Authentication failed: you do not have permissions to access the service.
    /// (HTTP 401)
    ///
    case serviceAccessDenied

    ///
    /// Invalid format: this service doesn't exist in that format. (HTTP 405)
    ///
    case invalidFormat

    ///
    /// Invalid parameters: your request parameters are incorrect. (HTTP 422)
    ///
    case invalidParameters

    ///
    /// Invalid id: the pre-requisite id is invalid or not found. (HTTP 404)
    ///
    case invalidID

    ///
    /// Invalid API key: you must be granted a valid key. (HTTP 401)
    ///
    case invalidAPIKey

    ///
    /// Duplicate entry: the data you tried to submit already exists. (HTTP 403)
    ///
    case duplicateEntry

    ///
    /// Service offline: this service is temporarily offline, try again later.
    /// (HTTP 503)
    ///
    case serviceOffline

    ///
    /// Suspended API key: access to your account has been suspended, contact
    /// TMDb. (HTTP 401)
    ///
    case suspendedAPIKey

    ///
    /// Internal error: something went wrong, contact TMDb. (HTTP 500)
    ///
    case internalError

    ///
    /// The item/record was updated successfully. (HTTP 201)
    ///
    case itemUpdated

    ///
    /// The item/record was deleted successfully. (HTTP 200)
    ///
    case itemDeleted

    ///
    /// Authentication failed. (HTTP 401)
    ///
    case authenticationFailed

    ///
    /// Failed. (HTTP 500)
    ///
    case failed

    ///
    /// Device denied. (HTTP 401)
    ///
    case deviceDenied

    ///
    /// Session denied. (HTTP 401)
    ///
    case sessionDenied

    ///
    /// Validation failed. (HTTP 400)
    ///
    case validationFailed

    ///
    /// Invalid accept header. (HTTP 406)
    ///
    case invalidAcceptHeader

    ///
    /// Invalid date range: should be a range no longer than 14 days. (HTTP 422)
    ///
    case invalidDateRange

    ///
    /// Entry not found: the item you are trying to edit cannot be found.
    /// (HTTP 200)
    ///
    case entryNotFound

    ///
    /// Invalid page: pages start at 1 and max at 500, and are expected to be an
    /// integer. (HTTP 400)
    ///
    case invalidPage

    ///
    /// Invalid date: format needs to be `YYYY-MM-DD`. (HTTP 400)
    ///
    case invalidDate

    ///
    /// Your request to the backend server timed out. Try again. (HTTP 504)
    ///
    case backendTimeout

    ///
    /// Your request count is over the allowed limit. (HTTP 429)
    ///
    case rateLimitExceeded

    ///
    /// You must provide a username and password. (HTTP 400)
    ///
    case missingUsernameOrPassword

    ///
    /// Too many append-to-response objects: the maximum number of remote calls is
    /// 20. (HTTP 400)
    ///
    case tooManyAppendToResponseObjects

    ///
    /// Invalid timezone: please consult the documentation for a valid timezone.
    /// (HTTP 400)
    ///
    case invalidTimezone

    ///
    /// You must confirm this action: please provide a `confirm=true` parameter.
    /// (HTTP 400)
    ///
    case actionMustBeConfirmed

    ///
    /// Invalid username and/or password: you did not provide a valid login.
    /// (HTTP 401)
    ///
    case invalidCredentials

    ///
    /// Account disabled: your account is no longer active. Contact TMDb if this is
    /// an error. (HTTP 401)
    ///
    case accountDisabled

    ///
    /// Email not verified: your email address has not been verified. (HTTP 401)
    ///
    case emailNotVerified

    ///
    /// Invalid request token: the request token is either expired or invalid.
    /// (HTTP 401)
    ///
    case invalidRequestToken

    ///
    /// The resource you requested could not be found. (HTTP 404)
    ///
    case resourceNotFound

    ///
    /// Invalid token. (HTTP 401)
    ///
    case invalidToken

    ///
    /// This token hasn't been granted write permission by the user. (HTTP 401)
    ///
    case tokenLacksWritePermission

    ///
    /// The requested session could not be found. (HTTP 404)
    ///
    case sessionNotFound

    ///
    /// You don't have permission to edit this resource. (HTTP 401)
    ///
    case editPermissionDenied

    ///
    /// This resource is private. (HTTP 401)
    ///
    case resourcePrivate

    ///
    /// Nothing to update. (HTTP 200)
    ///
    case nothingToUpdate

    ///
    /// This request token hasn't been approved by the user. (HTTP 422)
    ///
    case requestTokenNotApproved

    ///
    /// This request method is not supported for this resource. (HTTP 405)
    ///
    case requestMethodNotSupported

    ///
    /// Couldn't connect to the backend server. (HTTP 502)
    ///
    case backendConnectionFailed

    ///
    /// The id is invalid. (HTTP 500)
    ///
    case idInvalid

    ///
    /// This user has been suspended. (HTTP 403)
    ///
    case userSuspended

    ///
    /// The API is undergoing maintenance. Try again later. (HTTP 503)
    ///
    case apiUndergoingMaintenance

    ///
    /// The input is not valid. (HTTP 400)
    ///
    case invalidInput

    ///
    /// A status code not modelled by this library.
    ///
    /// Holds the raw numeric value TMDb returned. This case only ever carries an
    /// **undocumented** code — documented codes always classify to their named
    /// case via ``init(rawValue:)``.
    ///
    /// - Parameter rawValue: The raw TMDb status code.
    ///
    case unknown(Int)

}
