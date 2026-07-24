//
//  TMDbStatusCode+RawRepresentable.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension TMDbStatusCode {

    ///
    /// Creates a status code from its raw TMDb numeric value.
    ///
    /// A value documented by TMDb maps to its named case; any other value maps to
    /// ``unknown(_:)``, preserving the raw value. This initialiser therefore never
    /// returns `nil` — it is failable only to satisfy `RawRepresentable`.
    ///
    /// - Parameter rawValue: The raw TMDb status code.
    ///
    init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .success
        case 2: self = .invalidService
        case 3: self = .serviceAccessDenied
        case 4: self = .invalidFormat
        case 5: self = .invalidParameters
        case 6: self = .invalidID
        case 7: self = .invalidAPIKey
        case 8: self = .duplicateEntry
        case 9: self = .serviceOffline
        case 10: self = .suspendedAPIKey
        case 11: self = .internalError
        case 12: self = .itemUpdated
        case 13: self = .itemDeleted
        case 14: self = .authenticationFailed
        case 15: self = .failed
        case 16: self = .deviceDenied
        case 17: self = .sessionDenied
        case 18: self = .validationFailed
        case 19: self = .invalidAcceptHeader
        case 20: self = .invalidDateRange
        case 21: self = .entryNotFound
        case 22: self = .invalidPage
        case 23: self = .invalidDate
        case 24: self = .backendTimeout
        case 25: self = .rateLimitExceeded
        case 26: self = .missingUsernameOrPassword
        case 27: self = .tooManyAppendToResponseObjects
        case 28: self = .invalidTimezone
        case 29: self = .actionMustBeConfirmed
        case 30: self = .invalidCredentials
        case 31: self = .accountDisabled
        case 32: self = .emailNotVerified
        case 33: self = .invalidRequestToken
        case 34: self = .resourceNotFound
        case 35: self = .invalidToken
        case 36: self = .tokenLacksWritePermission
        case 37: self = .sessionNotFound
        case 38: self = .editPermissionDenied
        case 39: self = .resourcePrivate
        case 40: self = .nothingToUpdate
        case 41: self = .requestTokenNotApproved
        case 42: self = .requestMethodNotSupported
        case 43: self = .backendConnectionFailed
        case 44: self = .idInvalid
        case 45: self = .userSuspended
        case 46: self = .apiUndergoingMaintenance
        case 47: self = .invalidInput
        default: self = .unknown(rawValue)
        }
    }

    ///
    /// The raw TMDb numeric status code.
    ///
    var rawValue: Int {
        switch self {
        case .success: 1
        case .invalidService: 2
        case .serviceAccessDenied: 3
        case .invalidFormat: 4
        case .invalidParameters: 5
        case .invalidID: 6
        case .invalidAPIKey: 7
        case .duplicateEntry: 8
        case .serviceOffline: 9
        case .suspendedAPIKey: 10
        case .internalError: 11
        case .itemUpdated: 12
        case .itemDeleted: 13
        case .authenticationFailed: 14
        case .failed: 15
        case .deviceDenied: 16
        case .sessionDenied: 17
        case .validationFailed: 18
        case .invalidAcceptHeader: 19
        case .invalidDateRange: 20
        case .entryNotFound: 21
        case .invalidPage: 22
        case .invalidDate: 23
        case .backendTimeout: 24
        case .rateLimitExceeded: 25
        case .missingUsernameOrPassword: 26
        case .tooManyAppendToResponseObjects: 27
        case .invalidTimezone: 28
        case .actionMustBeConfirmed: 29
        case .invalidCredentials: 30
        case .accountDisabled: 31
        case .emailNotVerified: 32
        case .invalidRequestToken: 33
        case .resourceNotFound: 34
        case .invalidToken: 35
        case .tokenLacksWritePermission: 36
        case .sessionNotFound: 37
        case .editPermissionDenied: 38
        case .resourcePrivate: 39
        case .nothingToUpdate: 40
        case .requestTokenNotApproved: 41
        case .requestMethodNotSupported: 42
        case .backendConnectionFailed: 43
        case .idInvalid: 44
        case .userSuspended: 45
        case .apiUndergoingMaintenance: 46
        case .invalidInput: 47
        case .unknown(let code): code
        }
    }

}

public extension TMDbStatusCode {

    ///
    /// Returns a Boolean value indicating whether two status codes are equal.
    ///
    /// Equality is based on the raw TMDb numeric value.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    ///
    /// - Returns: `true` if the raw values are equal, otherwise `false`.
    ///
    static func == (lhs: TMDbStatusCode, rhs: TMDbStatusCode) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    ///
    /// Hashes the essential component of the status code.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    ///
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

}
