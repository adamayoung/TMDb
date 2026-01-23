//
//  CreateListResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the result of creating a list.
///
public struct CreateListResult: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the operation was successful.
    ///
    public let success: Bool

    ///
    /// Status message.
    ///
    public let statusMessage: String

    ///
    /// Status code.
    ///
    public let statusCode: Int

    ///
    /// ID of the created list.
    ///
    public let listID: Int

    ///
    /// Creates a create list result object.
    ///
    /// - Parameters:
    ///    - success: Whether the operation was successful.
    ///    - statusMessage: Status message.
    ///    - statusCode: Status code.
    ///    - listID: ID of the created list.
    ///
    public init(success: Bool, statusMessage: String, statusCode: Int, listID: Int) {
        self.success = success
        self.statusMessage = statusMessage
        self.statusCode = statusCode
        self.listID = listID
    }

}

extension CreateListResult {

    private enum CodingKeys: String, CodingKey {
        case success
        case statusMessage
        case statusCode
        case listID = "listId"
    }

}
