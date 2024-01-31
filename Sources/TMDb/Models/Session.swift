//
//  Session.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
/// A model representing a TMDb session.
///
public struct Session: Codable, Equatable, Hashable {

    ///
    /// Was session creation successful.
    ///
    public let success: Bool

    ///
    /// The session identifier.
    ///
    public let sessionID: String

    ///
    /// Creates a TMDb session object..
    ///
    /// - Parameters:
    ///   - success: Was token creation successful.
    ///   - sessionID: The session identifier.
    ///
    public init(success: Bool, sessionID: String) {
        self.success = success
        self.sessionID = sessionID
    }

}

extension Session {

    private enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "sessionId"
    }

}
