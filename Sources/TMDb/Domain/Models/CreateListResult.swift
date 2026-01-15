//
//  CreateListResult.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
